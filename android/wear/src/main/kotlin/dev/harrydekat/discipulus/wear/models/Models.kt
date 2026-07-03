package dev.harrydekat.discipulus.wear.models

import org.json.JSONObject
import java.util.Date
import java.io.Serializable

data class ScheduleEvent(
    val id: Int,
    val name: String,
    val shortName: String?,
    val location: String?,
    val infoType: Int,
    val status: Int,
    val startHourIndicator: Int?,
    val endHourIndicator: Int?,
    val startTime: Date,
    val endTime: Date,
    val isCompleted: Boolean
) : Serializable {
    companion object {
        fun fromJson(json: JSONObject): ScheduleEvent? {
            try {
                val id = json.optInt("id", -1)
                val name = json.optString("name", "")
                if (id == -1 || name.isEmpty()) return null

                val startMs = json.optLong("startTime", -1L)
                val endMs = json.optLong("endTime", -1L)
                if (startMs == -1L || endMs == -1L) return null

                val shortName = json.optString("shortName").takeIf { it.isNotEmpty() }
                val location = json.optString("location").takeIf { it.isNotEmpty() }
                val startHourIndicator = if (json.has("lesuurVan")) json.getInt("lesuurVan") else if (json.has("startHourIndicator")) json.getInt("startHourIndicator") else null
                val endHourIndicator = if (json.has("lesuurTotMet")) json.getInt("lesuurTotMet") else if (json.has("endHourIndicator")) json.getInt("endHourIndicator") else null

                return ScheduleEvent(
                    id = id,
                    name = name,
                    shortName = shortName,
                    location = location,
                    infoType = json.optInt("infoType", 0),
                    status = json.optInt("status", 0),
                    startHourIndicator = startHourIndicator,
                    endHourIndicator = endHourIndicator,
                    startTime = Date(startMs),
                    endTime = Date(endMs),
                    isCompleted = json.optBoolean("isCompleted", false)
                )
            } catch (e: Exception) {
                return null
            }
        }
    }
}

data class SubjectAverage(
    val subject: String,
    val subjectShort: String,
    val average: Double
) : Serializable {
    companion object {
        fun fromJson(json: JSONObject): SubjectAverage? {
            return try {
                SubjectAverage(
                    subject = json.getString("subject"),
                    subjectShort = json.getString("subjectShort"),
                    average = json.getDouble("average")
                )
            } catch (e: Exception) {
                null
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
    val description: String,
    val isPTA: Boolean,
    val date: Date?
) : Serializable {
    companion object {
        fun fromJson(json: JSONObject): WatchGrade? {
            try {
                val subject = json.getString("subject")
                val dateMs = if (json.has("date")) json.getLong("date") else 0L
                val date = if (dateMs > 0) Date(dateMs) else null

                return WatchGrade(
                    id = "$subject-$dateMs",
                    subject = subject,
                    grade = json.getString("grade"),
                    isVoldoende = json.getBoolean("isVoldoende"),
                    weight = if (json.has("weight")) json.getDouble("weight") else null,
                    description = json.optString("description", ""),
                    isPTA = json.optBoolean("isPTA", false),
                    date = date
                )
            } catch (e: Exception) { return null }
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
            try {
                val id = json.getInt("id")
                val name = json.getString("name")

                val averages = mutableListOf<SubjectAverage>()
                if (json.has("averages")) {
                    val arr = json.getJSONArray("averages")
                    for (i in 0 until arr.length()) {
                        SubjectAverage.fromJson(arr.getJSONObject(i))?.let { averages.add(it) }
                    }
                }

                val recentGrades = mutableListOf<WatchGrade>()
                if (json.has("recentGrades")) {
                    val arr = json.getJSONArray("recentGrades")
                    for (i in 0 until arr.length()) {
                        WatchGrade.fromJson(arr.getJSONObject(i))?.let { recentGrades.add(it) }
                    }
                }

                return SchoolYearData(id, name, averages, recentGrades)
            } catch (e: Exception) { return null }
        }
    }
}
