package dev.harrydekat.discipulus.wear.models

import android.util.Base64
import org.json.JSONArray
import org.json.JSONObject
import java.io.Serializable
import java.util.Date

data class CustomCalendarProperties(
    val status: Int? = null,
    val statusOriginal: Int? = null,
    val statusChanged: String? = null,
    val infoType: Int? = null,
    val infoTypeOriginal: Int? = null,
    val infoTypeChanged: String? = null,
    val inhoud: String? = null,
    val inhoudOriginal: String? = null,
    val inhoudChanged: String? = null,
    val lokatie: String? = null,
    val lokatieOriginal: String? = null,
    val lokatieChanged: String? = null
) : Serializable {
    companion object {
        private const val serialVersionUID = 1L

        fun fromAantekening(aantekening: String): CustomCalendarProperties? {
            if (aantekening.isBlank()) return null
            return try {
                val decodedBytes = Base64.decode(aantekening.trim(), Base64.DEFAULT)
                val jsonStr = String(decodedBytes, Charsets.UTF_8)
                fromJson(JSONObject(jsonStr))
            } catch (e: Exception) {
                null
            }
        }

        fun fromJson(json: JSONObject): CustomCalendarProperties {
            val status = if (json.has("Status") && !json.isNull("Status")) {
                json.optString("Status").toIntOrNull()
            } else null

            val statusOriginal = if (json.has("originalStatus") && !json.isNull("originalStatus")) {
                json.optString("originalStatus").toIntOrNull()
            } else null

            val infoType = if (json.has("InfoType") && !json.isNull("InfoType")) {
                json.optString("InfoType").toIntOrNull()
            } else null

            val infoTypeOriginal = if (json.has("originalInfoType") && !json.isNull("originalInfoType")) {
                json.optString("originalInfoType").toIntOrNull()
            } else null

            val inhoud = json.optString("Inhoud").takeIf { json.has("Inhoud") && !json.isNull("Inhoud") }
            val inhoudOriginal = json.optString("originalInhoud").takeIf { json.has("originalInhoud") && !json.isNull("originalInhoud") }

            val lokatie = json.optString("Lokatie").takeIf { json.has("Lokatie") && !json.isNull("Lokatie") }
            val lokatieOriginal = json.optString("originalLokatie").takeIf { json.has("originalLokatie") && !json.isNull("originalLokatie") }

            return CustomCalendarProperties(
                status = status,
                statusOriginal = statusOriginal,
                statusChanged = json.optString("dateStatus").takeIf { it.isNotEmpty() },
                infoType = infoType,
                infoTypeOriginal = infoTypeOriginal,
                infoTypeChanged = json.optString("dateInfoType").takeIf { it.isNotEmpty() },
                inhoud = inhoud,
                inhoudOriginal = inhoudOriginal,
                inhoudChanged = json.optString("dateInhoud").takeIf { it.isNotEmpty() },
                lokatie = lokatie,
                lokatieOriginal = lokatieOriginal,
                lokatieChanged = json.optString("dateLokatie").takeIf { it.isNotEmpty() }
            )
        }

        fun fromMap(map: Map<String, Any?>): CustomCalendarProperties {
            return CustomCalendarProperties(
                status = (map["Status"] as? Number)?.toInt(),
                statusOriginal = (map["originalStatus"] as? Number)?.toInt(),
                statusChanged = map["dateStatus"] as? String,
                infoType = (map["InfoType"] as? Number)?.toInt(),
                infoTypeOriginal = (map["originalInfoType"] as? Number)?.toInt(),
                infoTypeChanged = map["dateInfoType"] as? String,
                inhoud = map["Inhoud"] as? String,
                inhoudOriginal = map["originalInhoud"] as? String,
                inhoudChanged = map["dateInhoud"] as? String,
                lokatie = map["Lokatie"] as? String,
                lokatieOriginal = map["originalLokatie"] as? String,
                lokatieChanged = map["dateLokatie"] as? String
            )
        }
    }

    fun resolveStatus(rawStatus: Int): Int {
        if (status == null || statusOriginal == null) return rawStatus
        return if (statusOriginal == rawStatus) status else rawStatus
    }

    fun resolveInfoType(rawInfoType: Int): Int {
        if (infoType == null || infoTypeOriginal == null) return rawInfoType
        return if (infoTypeOriginal == rawInfoType) infoType else rawInfoType
    }

    fun resolveInhoud(rawInhoud: String?): String? {
        if (inhoud == null) return rawInhoud?.takeIf { it.isNotBlank() }
        val rawClean = rawInhoud?.takeIf { it.isNotBlank() }
        val origClean = inhoudOriginal?.takeIf { it.isNotBlank() }
        return if (rawClean == origClean) {
            inhoud.takeIf { it.isNotBlank() } ?: rawClean
        } else {
            rawClean
        }
    }

    fun resolveLokatie(rawLokatie: String?): String? {
        if (lokatie == null) return rawLokatie?.takeIf { it.isNotBlank() }
        val rawClean = rawLokatie?.takeIf { it.isNotBlank() }
        val origClean = lokatieOriginal?.takeIf { it.isNotBlank() }
        return if (rawClean == origClean) {
            lokatie.takeIf { it.isNotBlank() } ?: rawClean
        } else {
            rawClean
        }
    }

    fun toJson(): JSONObject {
        return JSONObject().apply {
            status?.let { put("Status", it) }
            statusOriginal?.let { put("originalStatus", it) }
            statusChanged?.let { put("dateStatus", it) }
            infoType?.let { put("InfoType", it) }
            infoTypeOriginal?.let { put("originalInfoType", it) }
            infoTypeChanged?.let { put("dateInfoType", it) }
            inhoud?.let { put("Inhoud", it) }
            inhoudOriginal?.let { put("originalInhoud", it) }
            inhoudChanged?.let { put("dateInhoud", it) }
            lokatie?.let { put("Lokatie", it) }
            lokatieOriginal?.let { put("originalLokatie", it) }
            lokatieChanged?.let { put("dateLokatie", it) }
        }
    }

    fun toAantekening(): String? {
        val hasAny = status != null || infoType != null || !lokatie.isNullOrEmpty() || !inhoud.isNullOrEmpty()
        if (!hasAny) return null
        return try {
            val jsonStr = toJson().toString()
            Base64.encodeToString(jsonStr.toByteArray(Charsets.UTF_8), Base64.NO_WRAP)
        } catch (e: Exception) {
            null
        }
    }
}

data class ScheduleEvent(
    val id: Int,
    val name: String,
    val shortName: String?,
    val location: String?,
    val description: String? = null,
    val teacher: String? = null,
    val infoType: Int,
    val status: Int,
    val startHourIndicator: Int?,
    val endHourIndicator: Int?,
    val startTime: Date,
    val endTime: Date,
    val isCompleted: Boolean = false,
    val customCalendarProperties: CustomCalendarProperties? = null
) : Serializable {
    val isCanceled: Boolean
        get() = status in 4..5

    val isAllDay: Boolean
        get() = (endTime.time - startTime.time) >= 12 * 3600 * 1000L || (startHourIndicator == null && (endTime.time - startTime.time) >= 8 * 3600 * 1000L)

    companion object {
        fun fromJson(json: JSONObject): ScheduleEvent? {
            return try {
                val startHour = when {
                    json.has("startHourIndicator") && !json.isNull("startHourIndicator") -> json.getInt("startHourIndicator")
                    json.has("lesuurVan") && !json.isNull("lesuurVan") -> json.getInt("lesuurVan")
                    json.has("LesuurVan") && !json.isNull("LesuurVan") -> json.getInt("LesuurVan")
                    else -> null
                }
                val endHour = when {
                    json.has("endHourIndicator") && !json.isNull("endHourIndicator") -> json.getInt("endHourIndicator")
                    json.has("lesuurTotMet") && !json.isNull("lesuurTotMet") -> json.getInt("lesuurTotMet")
                    json.has("LesuurTotMet") && !json.isNull("LesuurTotMet") -> json.getInt("LesuurTotMet")
                    else -> null
                }

                val description = json.optString("description").ifEmpty {
                    json.optString("inhoud").ifEmpty {
                        json.optString("Inhoud", "")
                    }
                }.takeIf { it.isNotEmpty() }

                val teacher = json.optString("teacher").ifEmpty {
                    json.optString("docent").ifEmpty {
                        json.optString("Docent", "")
                    }
                }.takeIf { it.isNotEmpty() }

                val customProperties = when {
                    json.has("customCalendarProperties") && !json.isNull("customCalendarProperties") -> {
                        val cpObj = json.optJSONObject("customCalendarProperties")
                        if (cpObj != null) CustomCalendarProperties.fromJson(cpObj) else null
                    }
                    json.has("aantekening") && !json.isNull("aantekening") -> {
                        CustomCalendarProperties.fromAantekening(json.getString("aantekening"))
                    }
                    json.has("Aantekening") && !json.isNull("Aantekening") -> {
                        CustomCalendarProperties.fromAantekening(json.getString("Aantekening"))
                    }
                    else -> null
                }

                ScheduleEvent(
                    id = json.getInt("id"),
                    name = json.getString("name"),
                    shortName = json.optString("shortName").takeIf { it.isNotEmpty() },
                    location = json.optString("location").takeIf { it.isNotEmpty() },
                    description = description,
                    teacher = teacher,
                    infoType = json.optInt("infoType", 0),
                    status = json.optInt("status", 0),
                    startHourIndicator = startHour,
                    endHourIndicator = endHour,
                    startTime = Date(json.getLong("startTime")),
                    endTime = Date(json.getLong("endTime")),
                    isCompleted = json.optBoolean("isCompleted", false),
                    customCalendarProperties = customProperties
                )
            } catch (e: Exception) {
                null
            }
        }

        fun fromMap(map: Map<String, Any?>): ScheduleEvent? {
            return try {
                val id = (map["id"] as? Number)?.toInt() ?: return null
                val name = map["name"] as? String ?: "Afspraak"
                val shortName = (map["shortName"] as? String)?.takeIf { it.isNotEmpty() }
                val location = (map["location"] as? String)?.takeIf { it.isNotEmpty() }
                val description = (map["description"] as? String)?.takeIf { it.isNotEmpty() }
                    ?: (map["inhoud"] as? String)?.takeIf { it.isNotEmpty() }
                    ?: (map["Inhoud"] as? String)?.takeIf { it.isNotEmpty() }
                val teacher = (map["teacher"] as? String)?.takeIf { it.isNotEmpty() }
                    ?: (map["docent"] as? String)?.takeIf { it.isNotEmpty() }
                    ?: (map["Docent"] as? String)?.takeIf { it.isNotEmpty() }
                val infoType = (map["infoType"] as? Number)?.toInt() ?: 0
                val status = (map["status"] as? Number)?.toInt() ?: 0
                val startHour = (map["startHourIndicator"] as? Number)?.toInt()
                    ?: (map["lesuurVan"] as? Number)?.toInt()
                    ?: (map["LesuurVan"] as? Number)?.toInt()
                val endHour = (map["endHourIndicator"] as? Number)?.toInt()
                    ?: (map["lesuurTotMet"] as? Number)?.toInt()
                    ?: (map["LesuurTotMet"] as? Number)?.toInt()
                val startTime = Date((map["startTime"] as? Number)?.toLong() ?: return null)
                val endTime = Date((map["endTime"] as? Number)?.toLong() ?: return null)
                val isCompleted = map["isCompleted"] as? Boolean ?: false

                @Suppress("UNCHECKED_CAST")
                val customProperties = when {
                    map["customCalendarProperties"] is Map<*, *> -> {
                        CustomCalendarProperties.fromMap(map["customCalendarProperties"] as Map<String, Any?>)
                    }
                    map["aantekening"] is String -> {
                        CustomCalendarProperties.fromAantekening(map["aantekening"] as String)
                    }
                    map["Aantekening"] is String -> {
                        CustomCalendarProperties.fromAantekening(map["Aantekening"] as String)
                    }
                    else -> null
                }

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
                    startTime = startTime,
                    endTime = endTime,
                    isCompleted = isCompleted,
                    customCalendarProperties = customProperties
                )
            } catch (e: Exception) {
                null
            }
        }
    }

    fun toJson(): JSONObject {
        return JSONObject().apply {
            put("id", id)
            put("name", name)
            put("shortName", shortName)
            put("location", location)
            put("description", description)
            put("teacher", teacher)
            put("infoType", infoType)
            put("status", status)
            put("startHourIndicator", startHourIndicator)
            put("endHourIndicator", endHourIndicator)
            put("startTime", startTime.time)
            put("endTime", endTime.time)
            put("isCompleted", isCompleted)
            customCalendarProperties?.let {
                put("customCalendarProperties", it.toJson())
            }
        }
    }
}

data class WatchGrade(
    val id: String,
    val subject: String,
    val grade: String,
    val isVoldoende: Boolean,
    val weight: Double?,
    val description: String?,
    val isPTA: Boolean,
    val date: Date?
) : Serializable {
    companion object {
        fun fromJson(json: JSONObject): WatchGrade? {
            return try {
                WatchGrade(
                    id = json.getString("id"),
                    subject = json.getString("subject"),
                    grade = json.getString("grade"),
                    isVoldoende = json.optBoolean("isVoldoende", true),
                    weight = if (json.has("weight") && !json.isNull("weight")) json.getDouble("weight") else null,
                    description = json.optString("description").takeIf { it.isNotEmpty() },
                    isPTA = json.optBoolean("isPTA", false),
                    date = if (json.has("date") && !json.isNull("date")) Date(json.getLong("date")) else null
                )
            } catch (e: Exception) {
                null
            }
        }
    }

    fun toJson(): JSONObject {
        return JSONObject().apply {
            put("id", id)
            put("subject", subject)
            put("grade", grade)
            put("isVoldoende", isVoldoende)
            put("weight", weight)
            put("description", description)
            put("isPTA", isPTA)
            put("date", date?.time)
        }
    }
}

data class SubjectAverage(
    val subject: String,
    val average: Double?
) : Serializable {
    companion object {
        fun fromJson(json: JSONObject): SubjectAverage? {
            return try {
                SubjectAverage(
                    subject = json.getString("subject"),
                    average = if (json.has("average") && !json.isNull("average")) json.getDouble("average") else null
                )
            } catch (e: Exception) {
                null
            }
        }
    }

    fun toJson(): JSONObject {
        return JSONObject().apply {
            put("subject", subject)
            put("average", average)
        }
    }
}

data class SchoolYearData(
    val id: Int,
    val name: String,
    val averages: List<SubjectAverage>,
    val recentGrades: List<WatchGrade>
) : Serializable {
    companion object {
        fun fromJson(json: JSONObject): SchoolYearData? {
            return try {
                val averagesArr = json.optJSONArray("averages") ?: JSONArray()
                val averages = mutableListOf<SubjectAverage>()
                for (i in 0 until averagesArr.length()) {
                    averagesArr.optJSONObject(i)?.let { SubjectAverage.fromJson(it)?.let { sa -> averages.add(sa) } }
                }

                val gradesArr = json.optJSONArray("recentGrades") ?: JSONArray()
                val grades = mutableListOf<WatchGrade>()
                for (i in 0 until gradesArr.length()) {
                    gradesArr.optJSONObject(i)?.let { WatchGrade.fromJson(it)?.let { wg -> grades.add(wg) } }
                }

                SchoolYearData(
                    id = json.getInt("id"),
                    name = json.getString("name"),
                    averages = averages,
                    recentGrades = grades
                )
            } catch (e: Exception) {
                null
            }
        }
    }

    fun toJson(): JSONObject {
        return JSONObject().apply {
            put("id", id)
            put("name", name)
            put("averages", JSONArray().apply { averages.forEach { put(it.toJson()) } })
            put("recentGrades", JSONArray().apply { recentGrades.forEach { put(it.toJson()) } })
        }
    }
}

data class StandaloneAccount(
    val accessToken: String,
    val refreshToken: String,
    val idToken: String,
    val expiresAt: Long,
    val apiEndpoint: String,
    val personId: Int,
    val accountName: String
) : Serializable {
    companion object {
        fun fromMap(map: Map<String, Any?>): StandaloneAccount? {
            return try {
                val accessToken = map["accessToken"]?.toString() ?: return null
                val refreshToken = map["refreshToken"]?.toString() ?: ""
                val idToken = map["idToken"]?.toString() ?: ""
                val rawExpires = (map["expiresAt"] as? Number)?.toLong() ?: 0L
                val expiresAt = if (rawExpires > 0) rawExpires else (System.currentTimeMillis() + 3600_000L)
                val apiEndpoint = (map["apiEndpoint"]?.toString() ?: return null).trimEnd('/')
                val personId = (map["personId"] as? Number)?.toInt() ?: 0
                val accountName = map["accountName"]?.toString() ?: "Magister"

                StandaloneAccount(
                    accessToken = accessToken,
                    refreshToken = refreshToken,
                    idToken = idToken,
                    expiresAt = expiresAt,
                    apiEndpoint = apiEndpoint,
                    personId = personId,
                    accountName = accountName
                )
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }

        fun fromJson(json: JSONObject): StandaloneAccount? {
            return try {
                val rawExpires = json.optLong("expiresAt", 0L)
                val expiresAt = if (rawExpires > 0) rawExpires else (System.currentTimeMillis() + 3600_000L)
                StandaloneAccount(
                    accessToken = json.getString("accessToken"),
                    refreshToken = json.optString("refreshToken", ""),
                    idToken = json.optString("idToken", ""),
                    expiresAt = expiresAt,
                    apiEndpoint = json.getString("apiEndpoint").trimEnd('/'),
                    personId = json.optInt("personId", 0),
                    accountName = json.optString("accountName", "Magister")
                )
            } catch (e: Exception) {
                null
            }
        }
    }

    fun toJson(): JSONObject {
        return JSONObject().apply {
            put("accessToken", accessToken)
            put("refreshToken", refreshToken)
            put("idToken", idToken)
            put("expiresAt", expiresAt)
            put("apiEndpoint", apiEndpoint)
            put("personId", personId)
            put("accountName", accountName)
        }
    }
}
