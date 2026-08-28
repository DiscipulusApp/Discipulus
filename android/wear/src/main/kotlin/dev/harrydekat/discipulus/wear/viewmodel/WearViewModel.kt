package dev.harrydekat.discipulus.wear.viewmodel

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.Application
import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.util.Log
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.Wearable
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import dev.harrydekat.discipulus.wear.models.SchoolYearData
import dev.harrydekat.discipulus.wear.models.StandaloneAccount
import dev.harrydekat.discipulus.wear.models.SubjectAverage
import dev.harrydekat.discipulus.wear.models.WatchGrade
import dev.harrydekat.discipulus.wear.receivers.WearReminderReceiver
import dev.harrydekat.discipulus.wear.services.NavigatorComplicationService
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.ObjectInputStream
import java.io.ObjectOutputStream
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class WearViewModel(application: Application) : AndroidViewModel(application), MessageClient.OnMessageReceivedListener {

    private val messageClient by lazy { Wearable.getMessageClient(application) }

    private val prefs by lazy {
        application.getSharedPreferences("discipulus_wear_prefs", Context.MODE_PRIVATE)
    }

    private val _schedule = MutableStateFlow<Map<String, List<ScheduleEvent>>>(emptyMap())
    val schedule: StateFlow<Map<String, List<ScheduleEvent>>> = _schedule.asStateFlow()

    private val _schoolyears = MutableStateFlow<List<SchoolYearData>>(emptyList())
    val schoolyears: StateFlow<List<SchoolYearData>> = _schoolyears.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _showBreakSeparators = MutableStateFlow(prefs.getBoolean("show_break_separators", true))
    val showBreakSeparators: StateFlow<Boolean> = _showBreakSeparators.asStateFlow()

    private val _showCancelledLessons = MutableStateFlow(
        prefs.getBoolean("show_cancelled_lessons", false)
    )
    val showCancelledLessons: StateFlow<Boolean> = _showCancelledLessons.asStateFlow()

    private val _hapticsEnabled = MutableStateFlow(prefs.getBoolean("haptics_enabled", true))
    val hapticsEnabled: StateFlow<Boolean> = _hapticsEnabled.asStateFlow()

    private val _hapticOffset = MutableStateFlow(prefs.getInt("haptic_offset", 5))
    val hapticOffset: StateFlow<Int> = _hapticOffset.asStateFlow()

    private val _currentEvent = MutableStateFlow<ScheduleEvent?>(null)
    val currentEvent: StateFlow<ScheduleEvent?> = _currentEvent.asStateFlow()

    private val _nextEvent = MutableStateFlow<ScheduleEvent?>(null)
    val nextEvent: StateFlow<ScheduleEvent?> = _nextEvent.asStateFlow()

    private val _eventTimeDisplay = MutableStateFlow(prefs.getInt("event_time_display", 0))
    val eventTimeDisplay: StateFlow<Int> = _eventTimeDisplay.asStateFlow()

    private val _scheduleViewMode = MutableStateFlow(prefs.getInt("schedule_view_mode", 0))
    val scheduleViewMode: StateFlow<Int> = _scheduleViewMode.asStateFlow()

    private val _selectedGrade = MutableStateFlow<WatchGrade?>(null)
    val selectedGrade: StateFlow<WatchGrade?> = _selectedGrade.asStateFlow()

    private val _selectedEvent = MutableStateFlow<ScheduleEvent?>(null)
    val selectedEvent: StateFlow<ScheduleEvent?> = _selectedEvent.asStateFlow()

    private val _lastUpdate = MutableStateFlow<Date?>(null)
    val lastUpdate: StateFlow<Date?> = _lastUpdate.asStateFlow()

    private val _isStandaloneMode = MutableStateFlow(prefs.getBoolean("is_standalone_mode", false))
    val isStandaloneMode: StateFlow<Boolean> = _isStandaloneMode.asStateFlow()

    private val _standaloneAccount = MutableStateFlow<StandaloneAccount?>(loadStandaloneAccount())
    val standaloneAccount: StateFlow<StandaloneAccount?> = _standaloneAccount.asStateFlow()

    private val _statusMessage = MutableStateFlow<String?>(null)
    val statusMessage: StateFlow<String?> = _statusMessage.asStateFlow()

    private val _startDestination = MutableStateFlow(prefs.getString("start_destination", "home") ?: "home")
    val startDestination: StateFlow<String> = _startDestination.asStateFlow()

    fun selectGrade(grade: WatchGrade?) {
        _selectedGrade.value = grade
    }

    fun selectEvent(event: ScheduleEvent?) {
        _selectedEvent.value = event
    }

    fun setEventTimeDisplay(mode: Int) {
        _eventTimeDisplay.value = mode
        prefs.edit().putInt("event_time_display", mode).apply()
    }

    fun setScheduleViewMode(mode: Int) {
        _scheduleViewMode.value = mode
        prefs.edit().putInt("schedule_view_mode", mode).apply()
    }

    fun setStartDestination(destination: String) {
        _startDestination.value = destination
        prefs.edit().putString("start_destination", destination).apply()
    }

    init {
        messageClient.addListener(this)
        loadFromDisk()
        refreshAll()

        viewModelScope.launch {
            while (true) {
                updateCurrentEvent()
                val last = _lastUpdate.value?.time ?: 0L
                val now = System.currentTimeMillis()
                if (now - last > 15 * 60 * 1000) {
                    refreshAll()
                }
                kotlinx.coroutines.delay(60000)
            }
        }
    }

    override fun onCleared() {
        super.onCleared()
        messageClient.removeListener(this)
    }

    fun setShowBreakSeparators(value: Boolean) {
        _showBreakSeparators.value = value
        prefs.edit().putBoolean("show_break_separators", value).apply()
    }

    fun setShowCancelledLessons(value: Boolean) {
        _showCancelledLessons.value = value
        prefs.edit().putBoolean("show_cancelled_lessons", value).apply()
    }

    fun setHapticsEnabled(value: Boolean) {
        _hapticsEnabled.value = value
        prefs.edit().putBoolean("haptics_enabled", value).apply()
        scheduleReminders()
    }

    fun setHapticOffset(value: Int) {
        _hapticOffset.value = value
        prefs.edit().putInt("haptic_offset", value).apply()
        scheduleReminders()
    }

    fun triggerPhoneSetup() {
        sendMessageToPhone("watch_connectivity", mapOf("command" to "open_watch_setup"))
    }

    fun switchToCompanionMode() {
        saveStandaloneAccount(null)
        requestSchedule()
        requestGrades()
    }

    fun logoutStandalone() {
        saveStandaloneAccount(null)
    }

    private fun loadStandaloneAccount(): StandaloneAccount? {
        val jsonStr = prefs.getString("standalone_account", null) ?: return null
        return try {
            StandaloneAccount.fromJson(JSONObject(jsonStr))
        } catch (e: Exception) {
            null
        }
    }

    private fun saveStandaloneAccount(account: StandaloneAccount?) {
        _standaloneAccount.value = account
        val editor = prefs.edit()
        if (account != null) {
            editor.putString("standalone_account", account.toJson().toString())
            editor.putBoolean("is_standalone_mode", true)
            _isStandaloneMode.value = true
        } else {
            editor.remove("standalone_account")
            editor.putBoolean("is_standalone_mode", false)
            _isStandaloneMode.value = false
        }
        editor.apply()
    }

    private suspend fun <T> executeWithNetwork(block: suspend () -> T): T? = withContext(Dispatchers.IO) {
        val context = getApplication<Application>()
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
        if (cm == null) return@withContext block()

        val networkRequest = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            .build()

        val completer = CompletableDeferred<Network?>()
        val callback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                cm.bindProcessToNetwork(network)
                if (!completer.isCompleted) completer.complete(network)
            }
            override fun onUnavailable() {
                if (!completer.isCompleted) completer.complete(null)
            }
        }

        try {
            cm.requestNetwork(networkRequest, callback, 10000)
            val network = withTimeoutOrNull(10000) { completer.await() }
            if (network != null) {
                cm.bindProcessToNetwork(network)
            }
            return@withContext block()
        } catch (e: Exception) {
            Log.e("WearViewModel", "Network error during execution", e)
            return@withContext null
        } finally {
            try {
                cm.unregisterNetworkCallback(callback)
            } catch (e: Exception) {}
        }
    }

    suspend fun ensureValidToken(): String? = withContext(Dispatchers.IO) {
        val account = _standaloneAccount.value ?: return@withContext null
        val now = System.currentTimeMillis()
        if (account.expiresAt > now + 300_000 && account.accessToken.isNotEmpty()) {
            return@withContext account.accessToken
        }

        if (account.refreshToken.isEmpty()) {
            return@withContext account.accessToken
        }

        executeWithNetwork {
            try {
                val url = URL("https://accounts.magister.net/connect/token")
                val conn = (url.openConnection() as HttpURLConnection).apply {
                    requestMethod = "POST"
                    doOutput = true
                    setRequestProperty("Content-Type", "application/x-www-form-urlencoded")
                    connectTimeout = 15000
                    readTimeout = 15000
                }

                val body = "client_id=M6LOAPP&grant_type=refresh_token&refresh_token=${URLEncoder.encode(account.refreshToken, "UTF-8")}"
                conn.outputStream.use { it.write(body.toByteArray(Charsets.UTF_8)) }

                if (conn.responseCode in 200..299) {
                    val responseText = conn.inputStream.bufferedReader().use { it.readText() }
                    val json = JSONObject(responseText)
                    val newAccessToken = json.getString("access_token")
                    val newRefreshToken = json.optString("refresh_token", account.refreshToken)
                    val expiresIn = json.optLong("expires_in", 3600L)
                    val newExpiresAt = System.currentTimeMillis() + (expiresIn * 1000)

                    val updatedAccount = account.copy(
                        accessToken = newAccessToken,
                        refreshToken = newRefreshToken,
                        expiresAt = newExpiresAt
                    )
                    saveStandaloneAccount(updatedAccount)
                    Log.i("WearViewModel", "Token refreshed successfully. Expires at: $newExpiresAt")
                    newAccessToken
                } else {
                    val err = conn.errorStream?.bufferedReader()?.use { it.readText() } ?: ""
                    Log.e("WearViewModel", "Failed to refresh token: HTTP ${conn.responseCode} - $err")
                    account.accessToken
                }
            } catch (e: Exception) {
                Log.e("WearViewModel", "Error refreshing token: ${e.message}", e)
                account.accessToken
            }
        } ?: account.accessToken
    }

    suspend fun ensureAccountDetails(): StandaloneAccount? = withContext(Dispatchers.IO) {
        val account = _standaloneAccount.value ?: return@withContext null
        if (account.personId != 0 && account.accountName != "Magister") {
            return@withContext account
        }
        val token = ensureValidToken() ?: return@withContext account
        executeWithNetwork {
            try {
                val endpoint = account.apiEndpoint.trimEnd('/')
                val url = URL("$endpoint/account")
                val conn = (url.openConnection() as HttpURLConnection).apply {
                    requestMethod = "GET"
                    setRequestProperty("Authorization", "Bearer $token")
                    setRequestProperty("Accept", "application/json")
                    connectTimeout = 15000
                    readTimeout = 15000
                }

                if (conn.responseCode in 200..299) {
                    val responseText = conn.inputStream.bufferedReader().use { it.readText() }
                    val json = JSONObject(responseText)
                    val persoon = json.optJSONObject("Persoon")
                    val pId = persoon?.optInt("Id", 0) ?: 0
                    val pName = persoon?.optString("Roepnaam")?.takeIf { it.isNotEmpty() }
                        ?: persoon?.optString("OfficieleVoornamen")?.takeIf { it.isNotEmpty() }
                        ?: "Magister"
                    val updated = account.copy(personId = pId, accountName = pName)
                    saveStandaloneAccount(updated)
                    Log.i("WearViewModel", "Account details fetched: personId=$pId, name=$pName")
                    updated
                } else {
                    val err = conn.errorStream?.bufferedReader()?.use { it.readText() } ?: ""
                    Log.e("WearViewModel", "Failed to fetch account details: HTTP ${conn.responseCode} - $err")
                    account
                }
            } catch (e: Exception) {
                Log.e("WearViewModel", "Error fetching account details: ${e.message}", e)
                account
            }
        } ?: account
    }

    suspend fun fetchStandaloneSchedule() = executeWithNetwork {
        val account = ensureAccountDetails() ?: return@executeWithNetwork
        val token = ensureValidToken() ?: return@executeWithNetwork

        _isLoading.value = true
        try {
            val cal = Calendar.getInstance()
            cal.add(Calendar.DAY_OF_YEAR, -1)
            val fromDate = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(cal.time)
            cal.add(Calendar.DAY_OF_YEAR, 8)
            val toDate = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(cal.time)

            val rawEndpoint = account.apiEndpoint.trimEnd('/')
            val endpoint = if (rawEndpoint.endsWith("/api")) rawEndpoint else "$rawEndpoint/api"
            val personId = account.personId

            val url = URL("$endpoint/personen/$personId/afspraken?van=$fromDate&tot=$toDate")
            val conn = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                setRequestProperty("Authorization", "Bearer $token")
                setRequestProperty("Accept", "application/json")
                connectTimeout = 15000
                readTimeout = 15000
            }

            if (conn.responseCode in 200..299) {
                val responseText = conn.inputStream.bufferedReader().use { it.readText() }
                val json = JSONObject(responseText)
                val items = json.optJSONArray("Items") ?: json.optJSONArray("items") ?: JSONArray()
                val eventsList = mutableListOf<ScheduleEvent>()
                val isoFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US)

                for (i in 0 until items.length()) {
                    val item = items.optJSONObject(i) ?: continue
                    val id = item.optInt("Id", item.optInt("id", -1))
                    val name = item.optString("Omschrijving").ifEmpty {
                        item.optString("omschrijving").ifEmpty {
                            val vakken = item.optJSONArray("Vakken")
                            if (vakken != null && vakken.length() > 0) {
                                vakken.getJSONObject(0).optString("Naam", "Afspraak")
                            } else "Afspraak"
                        }
                    }
                    val startStr = item.optString("Start", item.optString("start", ""))
                    val endStr = item.optString("Einde", item.optString("einde", ""))
                    if (id == -1 || startStr.isEmpty() || endStr.isEmpty()) continue

                    val cleanStart = startStr.substringBefore("Z").substringBefore("+")
                    val cleanEnd = endStr.substringBefore("Z").substringBefore("+")
                    val startDate = try { isoFormat.parse(cleanStart) } catch (e: Exception) { null } ?: continue
                    val endDate = try { isoFormat.parse(cleanEnd) } catch (e: Exception) { null } ?: continue

                    var shortName: String? = null
                    val vakken = item.optJSONArray("Vakken") ?: item.optJSONArray("vakken")
                    if (vakken != null && vakken.length() > 0) {
                        shortName = vakken.getJSONObject(0).optString("Afkorting").ifEmpty {
                            vakken.getJSONObject(0).optString("afkorting", "")
                        }.takeIf { it.isNotEmpty() }
                    }

                    val location = item.optString("Lokatie").ifEmpty { item.optString("lokatie", "") }.takeIf { it.isNotEmpty() }
                    val description = item.optString("Inhoud").ifEmpty {
                        item.optString("inhoud").ifEmpty {
                            item.optString("Omschrijving", item.optString("omschrijving", ""))
                        }
                    }.takeIf { it.isNotEmpty() }

                    val docenten = item.optJSONArray("Docenten") ?: item.optJSONArray("docenten")
                    val teacher = if (docenten != null && docenten.length() > 0) {
                        val d = docenten.getJSONObject(0)
                        d.optString("Naam").ifEmpty {
                            d.optString("naam").ifEmpty {
                                d.optString("Docentcode", d.optString("docentcode", ""))
                            }
                        }.takeIf { it.isNotEmpty() }
                    } else null

                    val startHour = when {
                        item.has("LesuurVan") && !item.isNull("LesuurVan") -> item.getInt("LesuurVan")
                        item.has("lesuurVan") && !item.isNull("lesuurVan") -> item.getInt("lesuurVan")
                        else -> null
                    }
                    val endHour = when {
                        item.has("LesuurTotMet") && !item.isNull("LesuurTotMet") -> item.getInt("LesuurTotMet")
                        item.has("lesuurTotMet") && !item.isNull("lesuurTotMet") -> item.getInt("lesuurTotMet")
                        else -> null
                    }
                    val infoType = item.optInt("InfoType", item.optInt("infoType", 0))
                    val status = item.optInt("Status", item.optInt("status", 0))
                    val isCompleted = item.optBoolean("Afgerond", item.optBoolean("afgerond", false))

                    eventsList.add(
                        ScheduleEvent(
                            id = id,
                            name = name,
                            shortName = shortName,
                            location = location,
                            description = description,
                            teacher = teacher,
                            infoType = infoType,
                            status = status,
                            startHourIndicator = startHour,
                            endHourIndicator = endHour,
                            startTime = startDate,
                            endTime = endDate,
                            isCompleted = isCompleted
                        )
                    )
                }

                val scheduleMap = mutableMapOf<String, List<ScheduleEvent>>()
                val dayFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
                for (ev in eventsList) {
                    val dayKey = dayFormat.format(ev.startTime)
                    val list = scheduleMap.getOrPut(dayKey) { mutableListOf() } as MutableList<ScheduleEvent>
                    list.add(ev)
                }
                scheduleMap.keys.forEach { k ->
                    scheduleMap[k] = scheduleMap[k]!!.sortedBy { it.startTime }
                }

                _schedule.value = scheduleMap
                _lastUpdate.value = Date()
                updateCurrentEvent()
                scheduleReminders()
                saveToDisk()
            } else {
                val err = conn.errorStream?.bufferedReader()?.use { it.readText() } ?: ""
                Log.e("WearViewModel", "Failed to fetch standalone schedule: HTTP ${conn.responseCode} - $err")
            }
        } catch (e: Exception) {
            Log.e("WearViewModel", "Error in fetchStandaloneSchedule: ${e.message}", e)
        } finally {
            _isLoading.value = false
        }
    }

    suspend fun fetchStandaloneGrades() = executeWithNetwork {
        val account = ensureAccountDetails() ?: return@executeWithNetwork
        val token = ensureValidToken() ?: return@executeWithNetwork

        _isLoading.value = true
        try {
            val rawEndpoint = account.apiEndpoint.trimEnd('/')
            val endpoint = if (rawEndpoint.endsWith("/api")) rawEndpoint else "$rawEndpoint/api"
            val personId = account.personId

            val aanmeldingenCandidateUrls = listOf(
                "$endpoint/leerlingen/$personId/aanmeldingen?begin=2015-01-01&einde=2030-01-01",
                "$endpoint/leerlingen/$personId/aanmeldingen",
                "$endpoint/personen/$personId/aanmeldingen?begin=2015-01-01&einde=2030-01-01",
                "$endpoint/personen/$personId/aanmeldingen"
            )

            var itemsArray: JSONArray? = null
            for (urlStr in aanmeldingenCandidateUrls) {
                try {
                    val conn = (URL(urlStr).openConnection() as HttpURLConnection).apply {
                        requestMethod = "GET"
                        setRequestProperty("Authorization", "Bearer $token")
                        setRequestProperty("Accept", "application/json")
                        connectTimeout = 15000
                        readTimeout = 15000
                    }
                    if (conn.responseCode in 200..299) {
                        val responseText = conn.inputStream.bufferedReader().use { it.readText() }
                        val json = JSONObject(responseText)
                        val arr = json.optJSONArray("items") ?: json.optJSONArray("Items")
                        if (arr != null && arr.length() > 0) {
                            itemsArray = arr
                            break
                        }
                    }
                } catch (e: Exception) {
                    Log.w("WearViewModel", "Failed querying aanmeldingen at $urlStr: ${e.message}")
                }
            }

            val items = itemsArray ?: JSONArray()
            val syList = mutableListOf<SchoolYearData>()

            for (i in 0 until items.length()) {
                val aanmelding = items.optJSONObject(i) ?: continue
                val syId = aanmelding.optInt("id", aanmelding.optInt("Id", -1))
                if (syId == -1) continue

                val studie = aanmelding.optJSONObject("studie") ?: aanmelding.optJSONObject("Studie")
                val groep = aanmelding.optJSONObject("groep") ?: aanmelding.optJSONObject("Groep")
                val syName = studie?.optString("omschrijving")?.ifEmpty { null }
                    ?: studie?.optString("Omschrijving")?.ifEmpty { null }
                    ?: groep?.optString("omschrijving")?.ifEmpty { null }
                    ?: groep?.optString("Omschrijving")?.ifEmpty { null }
                    ?: aanmelding.optString("omschrijving", aanmelding.optString("Omschrijving", "Schooljaar"))

                val cijfersCandidateUrls = listOf(
                    "$endpoint/personen/$personId/aanmeldingen/$syId/cijfers/cijferoverzichtvooraanmelding?actievePerioden=false&alleenBerekendeKolommen=false&alleenPTAKolommen=false",
                    "$endpoint/leerlingen/$personId/aanmeldingen/$syId/cijfers/cijferoverzichtvooraanmelding?actievePerioden=false&alleenBerekendeKolommen=false&alleenPTAKolommen=false"
                )

                val recentGrades = mutableListOf<WatchGrade>()
                val isoFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.US)

                for (cUrlStr in cijfersCandidateUrls) {
                    try {
                        val cConn = (URL(cUrlStr).openConnection() as HttpURLConnection).apply {
                            requestMethod = "GET"
                            setRequestProperty("Authorization", "Bearer $token")
                            setRequestProperty("Accept", "application/json")
                            connectTimeout = 15000
                            readTimeout = 15000
                        }
                        if (cConn.responseCode in 200..299) {
                            val cText = cConn.inputStream.bufferedReader().use { it.readText() }
                            val cJson = JSONObject(cText)
                            val cItems = cJson.optJSONArray("Items") ?: cJson.optJSONArray("items") ?: JSONArray()

                            for (j in 0 until cItems.length()) {
                                val gItem = cItems.optJSONObject(j) ?: continue
                                val cijferStr = gItem.optString("CijferStr").ifEmpty { gItem.optString("cijferStr") }
                                if (cijferStr.isEmpty()) continue

                                val vak = gItem.optJSONObject("Vak") ?: gItem.optJSONObject("vak")
                                val vakNaam = vak?.optString("Omschrijving")?.takeIf { it.isNotEmpty() }
                                    ?: vak?.optString("omschrijving")?.takeIf { it.isNotEmpty() }
                                    ?: vak?.optString("Naam")?.takeIf { it.isNotEmpty() }
                                    ?: vak?.optString("naam")?.takeIf { it.isNotEmpty() }
                                    ?: "Onbekend"

                                val isVoldoende = gItem.optBoolean("IsVoldoende", gItem.optBoolean("isVoldoende", true))
                                val weight = when {
                                    gItem.has("Weegfactor") && !gItem.isNull("Weegfactor") -> gItem.getDouble("Weegfactor")
                                    gItem.has("Weging") && !gItem.isNull("Weging") -> gItem.getDouble("Weging")
                                    gItem.has("weegfactor") && !gItem.isNull("weegfactor") -> gItem.getDouble("weegfactor")
                                    gItem.has("weging") && !gItem.isNull("weging") -> gItem.getDouble("weging")
                                    else -> null
                                }
                                val kolom = gItem.optJSONObject("CijferKolom") ?: gItem.optJSONObject("cijferKolom")
                                val description = kolom?.optString("KolomOmschrijving")?.ifEmpty { null }
                                    ?: kolom?.optString("kolomOmschrijving")?.ifEmpty { null }
                                    ?: kolom?.optString("KolomKop")?.ifEmpty { null }
                                    ?: ""
                                val isPTA = kolom?.optBoolean("IsPtaKolom", kolom.optBoolean("isPtaKolom", false)) ?: false

                                val dateStr = gItem.optString("DatumIngevoerd").ifEmpty { gItem.optString("datumIngevoerd") }
                                val date = if (dateStr.isNotEmpty()) {
                                    try {
                                        isoFormat.parse(dateStr.substringBefore("Z").substringBefore("+"))
                                    } catch (e: Exception) { null }
                                } else null

                                val grade = WatchGrade(
                                    id = "$vakNaam-$j",
                                    subject = vakNaam,
                                    grade = cijferStr,
                                    isVoldoende = isVoldoende,
                                    weight = weight,
                                    description = description,
                                    isPTA = isPTA,
                                    date = date
                                )
                                recentGrades.add(grade)
                            }
                            break
                        }
                    } catch (e: Exception) {
                        Log.w("WearViewModel", "Failed querying cijfers at $cUrlStr: ${e.message}")
                    }
                }

                // Calculate subject averages from numeric grades
                val subjectGroups = recentGrades.groupBy { it.subject }
                val calculatedAverages = subjectGroups.mapNotNull { (subj, gList) ->
                    var totalWeighted = 0.0
                    var totalWeight = 0.0
                    for (g in gList) {
                        val num = g.grade.replace(',', '.').toDoubleOrNull()
                        if (num != null && num > 0.0) {
                            val w = if (g.weight != null && g.weight > 0) g.weight else 1.0
                            totalWeighted += num * w
                            totalWeight += w
                        }
                    }
                    if (totalWeight > 0.0) {
                        val avg = totalWeighted / totalWeight
                        val roundedAvg = Math.round(avg * 10.0) / 10.0
                        SubjectAverage(subject = subj, average = roundedAvg)
                    } else {
                        null
                    }
                }.sortedBy { it.subject }

                val sortedGrades = recentGrades.sortedWith(
                    compareByDescending { it.date?.time ?: 0L }
                )

                syList.add(SchoolYearData(syId, syName, calculatedAverages, sortedGrades))
            }

            if (syList.isNotEmpty()) {
                syList.sortByDescending { it.id }
                _schoolyears.value = syList
                _lastUpdate.value = Date()
                saveToDisk()
                Log.i("WearViewModel", "Successfully fetched standalone grades: ${syList.size} school years")
            } else {
                Log.w("WearViewModel", "No school years/grades found in standalone mode")
            }
        } catch (e: Exception) {
            Log.e("WearViewModel", "Error in fetchStandaloneGrades: ${e.message}", e)
        } finally {
            _isLoading.value = false
        }
    }

    fun toggleEventCompletion(id: Int) {
        val currentSchedule = _schedule.value.toMutableMap()
        var updatedEvent: ScheduleEvent? = null
        for ((key, events) in currentSchedule) {
            val index = events.indexOfFirst { it.id == id }
            if (index != -1) {
                val event = events[index]
                val toggled = event.copy(isCompleted = !event.isCompleted)
                updatedEvent = toggled
                val updatedList = events.toMutableList()
                updatedList[index] = toggled
                currentSchedule[key] = updatedList
                _schedule.value = currentSchedule

                updateCurrentEvent()
                scheduleReminders()
                break
            }
        }

        if (updatedEvent != null) {
            if (_selectedEvent.value?.id == id) {
                _selectedEvent.value = updatedEvent
            }
            saveToDisk()
            if (!_isStandaloneMode.value) {
                sendMessageToPhone("watch_connectivity", mapOf(
                    "command" to "toggle_event",
                    "id" to id,
                    "completed" to updatedEvent.isCompleted
                ))
            } else {
                viewModelScope.launch {
                    syncStandaloneEventCompletion(id, updatedEvent.isCompleted)
                }
            }
        }
    }

    private suspend fun syncStandaloneEventCompletion(id: Int, isCompleted: Boolean) = executeWithNetwork {
        val account = ensureAccountDetails() ?: return@executeWithNetwork
        val token = ensureValidToken() ?: return@executeWithNetwork

        try {
            val endpoint = account.apiEndpoint.trimEnd('/')
            val urlStr = "$endpoint/personen/${account.personId}/afspraken/$id"
            val url = URL(urlStr)
            val payload = JSONObject().apply {
                put("Id", id)
                put("Afgerond", isCompleted)
            }
            val conn = (url.openConnection() as HttpURLConnection).apply {
                requestMethod = "PUT"
                setRequestProperty("Authorization", "Bearer $token")
                setRequestProperty("Content-Type", "application/json")
                setRequestProperty("Accept", "application/json")
                doOutput = true
                connectTimeout = 15000
                readTimeout = 15000
            }
            conn.outputStream.use { os ->
                os.write(payload.toString().toByteArray(Charsets.UTF_8))
            }
            val responseCode = conn.responseCode
            Log.i("WearViewModel", "Standalone toggle event $id completion result: $responseCode")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun updateCurrentEvent() {
        val now = Date()
        val lessonEvents = _schedule.value.values.flatten()
            .filter { !it.isAllDay && !(it.isCompleted && it.infoType == 1) && it.status !in 4..5 }
            .sortedBy { it.startTime }

        val ongoing = lessonEvents.firstOrNull { it.startTime.time <= now.time && it.endTime.time > now.time }
        val upcoming = lessonEvents.firstOrNull { it.startTime.after(now) && it.id != ongoing?.id }

        _currentEvent.value = ongoing ?: upcoming?.takeIf { (it.startTime.time - now.time) <= 3 * 3600 * 1000L }
        _nextEvent.value = if (ongoing != null) upcoming?.takeIf { (it.startTime.time - ongoing.endTime.time) <= 45 * 60 * 1000L || (it.startTime.time - now.time) <= 3 * 3600 * 1000L } else null
    }

    @SuppressLint("ScheduleExactAlarm")
    fun scheduleReminders() {
        val alarmManager = getApplication<Application>().getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val context = getApplication<Application>()
        val now = Date()
        val allEvents = _schedule.value.values.flatten()
        val upcomingEvents = allEvents.filter {
            it.startTime.after(now) && !it.isCompleted && it.status !in 4..5
        }

        for (event in allEvents) {
            val intent = Intent(context, WearReminderReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                event.id,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            )
            if (pendingIntent != null) {
                alarmManager.cancel(pendingIntent)
                pendingIntent.cancel()
            }
        }

        if (!_hapticsEnabled.value) return

        val sortedUpcoming = upcomingEvents.sortedBy { it.startTime }
        for (event in sortedUpcoming.take(20)) {
            val reminderMs = event.startTime.time - (_hapticOffset.value * 60 * 1000)
            if (reminderMs < now.time) continue

            val intent = Intent(context, WearReminderReceiver::class.java).apply {
                putExtra("event_id", event.id)
                putExtra("event_name", event.name)
                putExtra("event_location", event.location)
                putExtra("offset", _hapticOffset.value)
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                event.id,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                if (alarmManager.canScheduleExactAlarms()) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        reminderMs,
                        pendingIntent
                    )
                } else {
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        reminderMs,
                        pendingIntent
                    )
                }
            } else if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    reminderMs,
                    pendingIntent
                )
            } else {
                alarmManager.set(
                    AlarmManager.RTC_WAKEUP,
                    reminderMs,
                    pendingIntent
                )
            }
        }
    }

    private fun serialize(`object`: Any): ByteArray {
        val baos = ByteArrayOutputStream()
        ObjectOutputStream(baos).use { it.writeObject(`object`) }
        return baos.toByteArray()
    }

    private fun deserialize(bytes: ByteArray): Any? {
        return try {
            val bais = ByteArrayInputStream(bytes)
            ObjectInputStream(bais).use { it.readObject() }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    fun saveToDisk() {
        try {
            val scheduleBytes = serialize(_schedule.value)
            val schoolyearsBytes = serialize(_schoolyears.value)
            val scheduleBase64 = android.util.Base64.encodeToString(scheduleBytes, android.util.Base64.DEFAULT)
            val schoolyearsBase64 = android.util.Base64.encodeToString(schoolyearsBytes, android.util.Base64.DEFAULT)
            val editor = prefs.edit()
            editor.putString("cached_schedule", scheduleBase64)
            editor.putString("cached_schoolyears", schoolyearsBase64)
            _lastUpdate.value?.time?.let { editor.putLong("last_update", it) }
            editor.apply()

            val component = ComponentName(getApplication<Application>(), NavigatorComplicationService::class.java)
            val requester = ComplicationDataSourceUpdateRequester.create(getApplication<Application>(), component)
            requester.requestUpdateAll()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun loadFromDisk() {
        try {
            val scheduleBase64 = prefs.getString("cached_schedule", null)
            val schoolyearsBase64 = prefs.getString("cached_schoolyears", null)
            val lastUpdateTime = prefs.getLong("last_update", 0L)

            if (scheduleBase64 != null) {
                val bytes = android.util.Base64.decode(scheduleBase64, android.util.Base64.DEFAULT)
                val map = deserialize(bytes) as? Map<String, List<ScheduleEvent>>
                if (map != null) {
                    _schedule.value = map
                    updateCurrentEvent()
                    scheduleReminders()
                }
            }
            if (schoolyearsBase64 != null) {
                val bytes = android.util.Base64.decode(schoolyearsBase64, android.util.Base64.DEFAULT)
                val list = deserialize(bytes) as? List<SchoolYearData>
                if (list != null) {
                    _schoolyears.value = list
                }
            }
            if (lastUpdateTime != 0L) {
                _lastUpdate.value = Date(lastUpdateTime)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun requestSchedule() {
        if (_isStandaloneMode.value && _standaloneAccount.value != null) {
            viewModelScope.launch { fetchStandaloneSchedule() }
        } else {
            sendMessageToPhone("watch_connectivity", mapOf("command" to "get_schedule"))
        }
    }

    fun requestGrades() {
        if (_isStandaloneMode.value && _standaloneAccount.value != null) {
            viewModelScope.launch { fetchStandaloneGrades() }
        } else {
            sendMessageToPhone("watch_connectivity", mapOf("command" to "get_grades"))
        }
    }

    fun refreshAll() {
        requestSchedule()
        requestGrades()
    }

    @SuppressLint("VisibleForTests")
    private fun sendMessageToPhone(path: String, payload: Map<String, Any>) {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val nodesContext = Wearable.getNodeClient(getApplication<Application>())
                val nodes = nodesContext.connectedNodes.await()
                val bytes = serialize(payload)
                nodes.forEach { node ->
                    messageClient.sendMessage(node.id, path, bytes).await()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                if (!_isStandaloneMode.value) {
                    _isLoading.value = false
                }
            }
        }
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        viewModelScope.launch {
            val dataMap = deserialize(messageEvent.data) as? Map<String, Any> ?: return@launch
            try {
                val json = JSONObject.wrap(dataMap) as? JSONObject ?: JSONObject()
                val type = json.optString("type")

                if (type == "tokenset") {
                    val rawData = dataMap["data"]
                    val account = when (rawData) {
                        is Map<*, *> -> @Suppress("UNCHECKED_CAST") StandaloneAccount.fromMap(rawData as Map<String, Any?>)
                        else -> {
                            val dataObj = json.optJSONObject("data") ?: JSONObject()
                            StandaloneAccount.fromJson(dataObj)
                        }
                    }
                    if (account != null) {
                        Log.i("WearViewModel", "Received standalone tokenset for endpoint ${account.apiEndpoint}, expiresAt=${account.expiresAt}")
                        saveStandaloneAccount(account)
                        fetchStandaloneSchedule()
                        fetchStandaloneGrades()
                    }
                } else if (type == "config_mode") {
                    val mode = json.optString("mode")
                    if (mode == "companion") {
                        switchToCompanionMode()
                    }
                } else if (type == "schedule") {
                    val dataObj = json.optJSONObject("data") ?: JSONObject()
                    val scheduleMap = mutableMapOf<String, List<ScheduleEvent>>()

                    dataObj.keys().forEach { key ->
                        val arr = dataObj.optJSONArray(key) ?: JSONArray()
                        val events = mutableListOf<ScheduleEvent>()
                        for (i in 0 until arr.length()) {
                            val eventJson = arr.optJSONObject(i) ?: continue
                            ScheduleEvent.fromJson(eventJson)?.let { events.add(it) }
                        }
                        scheduleMap[key] = events.sortedBy { it.startTime }
                    }
                    _schedule.value = scheduleMap
                    _lastUpdate.value = Date()
                    updateCurrentEvent()
                    scheduleReminders()
                    saveToDisk()
                    _isLoading.value = false
                } else if (type == "grades") {
                    val arr = json.optJSONArray("data") ?: JSONArray()
                    val syList = mutableListOf<SchoolYearData>()
                    for (i in 0 until arr.length()) {
                        val syJson = arr.optJSONObject(i) ?: continue
                        SchoolYearData.fromJson(syJson)?.let { syList.add(it) }
                    }
                    _schoolyears.value = syList
                    _lastUpdate.value = Date()
                    saveToDisk()
                    _isLoading.value = false
                }
            } catch (e: Exception) {
                e.printStackTrace()
                _isLoading.value = false
            }
        }
    }
}
