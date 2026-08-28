package dev.harrydekat.discipulus.wear.viewmodel

import android.annotation.SuppressLint
import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.Wearable
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import dev.harrydekat.discipulus.wear.models.SchoolYearData
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.ObjectInputStream
import java.io.ObjectOutputStream
import java.util.HashMap

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.ComponentName
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
import dev.harrydekat.discipulus.wear.receivers.WearReminderReceiver
import dev.harrydekat.discipulus.wear.services.NavigatorComplicationService
import dev.harrydekat.discipulus.wear.models.WatchGrade

class WearViewModel(application: Application) : AndroidViewModel(application), MessageClient.OnMessageReceivedListener {

    private val messageClient by lazy { Wearable.getMessageClient(application) }

    private val _schedule = MutableStateFlow<Map<String, List<ScheduleEvent>>>(emptyMap())
    val schedule: StateFlow<Map<String, List<ScheduleEvent>>> = _schedule.asStateFlow()

    private val _schoolyears = MutableStateFlow<List<SchoolYearData>>(emptyList())
    val schoolyears: StateFlow<List<SchoolYearData>> = _schoolyears.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val prefs by lazy {
        application.getSharedPreferences("discipulus_wear_prefs", Context.MODE_PRIVATE)
    }

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

    private val _selectedGrade = MutableStateFlow<WatchGrade?>(null)
    val selectedGrade: StateFlow<WatchGrade?> = _selectedGrade.asStateFlow()

    private val _lastUpdate = MutableStateFlow<java.util.Date?>(null)
    val lastUpdate: StateFlow<java.util.Date?> = _lastUpdate.asStateFlow()

    fun selectGrade(grade: WatchGrade?) {
        _selectedGrade.value = grade
    }

    init {
        messageClient.addListener(this)
        loadFromDisk()
        requestSchedule()
        requestGrades()

        viewModelScope.launch {
            while (true) {
                updateCurrentEvent()
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
            saveToDisk()
            sendMessageToPhone("watch_connectivity", mapOf(
                "command" to "toggle_event",
                "id" to id,
                "completed" to updatedEvent.isCompleted
            ))
        }
    }

    fun updateCurrentEvent() {
        val now = java.util.Date()
        val allEvents = _schedule.value.values.flatten()
            .filterNot { it.status in 4..5 }
            .sortedBy { it.startTime }

        val current = allEvents.firstOrNull { it.startTime.time <= now.time && it.endTime.time > now.time }
        if (current != null) {
            _currentEvent.value = current
            return
        }

        val next = allEvents.firstOrNull { it.startTime.after(now) }
        if (next != null) {
            if (next.startTime.time - now.time < 1800000) {
                _currentEvent.value = next
                return
            }
        }

        _currentEvent.value = null
    }

    @SuppressLint("ScheduleExactAlarm")
    fun scheduleReminders() {
        val alarmManager = getApplication<Application>().getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val context = getApplication<Application>()
        val now = java.util.Date()
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

            // Trigger Wear OS complication updates
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
                _lastUpdate.value = java.util.Date(lastUpdateTime)
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    fun requestSchedule() {
        sendMessageToPhone("watch_connectivity", mapOf("command" to "get_schedule"))
    }

    fun requestGrades() {
        sendMessageToPhone("watch_connectivity", mapOf("command" to "get_grades"))
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
            }
        }
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        viewModelScope.launch {
            val dataMap = deserialize(messageEvent.data) as? Map<String, Any> ?: return@launch
            try {
                val json = JSONObject.wrap(dataMap) as? JSONObject ?: JSONObject()
                val type = json.optString("type")

                if (type == "schedule") {
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
                    _lastUpdate.value = java.util.Date()
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
                    _lastUpdate.value = java.util.Date()
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
