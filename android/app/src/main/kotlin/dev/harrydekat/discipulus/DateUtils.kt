package dev.harrydekat.discipulus

import java.text.SimpleDateFormat
import java.util.*

object DateUtils {
    fun formatDate(timeInterval: Long, short: Boolean = false): String {
        if (timeInterval <= 0) return "Nu"

        val days = timeInterval / (24 * 60 * 60 * 1000)
        val hours = (timeInterval % (24 * 60 * 60 * 1000)) / (60 * 60 * 1000)
        val minutes = (timeInterval % (60 * 60 * 1000)) / (60 * 1000)

        return when {
            days > 0 -> "in ${days}${if (short) "d" else if (days > 1) " dagen" else " dag"}"
            hours > 0 -> "in ${hours}${if (short) "u" else if (hours > 1) " uren" else " uur"}"
            minutes > 0 -> "in ${minutes}${if (short) "m" else " min"}"
            else -> "Nu"
        }
    }

    fun formatTime(date: Date): String {
        val formatter = SimpleDateFormat("HH:mm", Locale.getDefault())
        return formatter.format(date)
    }

    fun formatDateHeader(date: Date): String {
        val formatter = SimpleDateFormat("EEEE d MMMM", Locale("nl", "NL"))
        return formatter.format(date)
    }
}