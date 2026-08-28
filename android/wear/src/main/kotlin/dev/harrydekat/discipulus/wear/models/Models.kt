package dev.harrydekat.discipulus.wear.models

import org.json.JSONArray
import org.json.JSONObject
import java.io.Serializable
import java.util.Date

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
    val isCompleted: Boolean = false
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
                    isCompleted = json.optBoolean("isCompleted", false)
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
                    isCompleted = isCompleted
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
