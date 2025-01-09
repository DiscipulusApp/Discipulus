package dev.harrydekat.discipulus

data class Event(
    val id: Int,
    val name: String,
    val shortName: String?,
    val location: String?,
    val infoType: Int,
    val startHourIndicator: Int?,
    val endHourIndicator: Int?,
    val startTime: Long,
    val endTime: Long,
    val isCompleted: Boolean
) {
    fun infotypeColor(noHomework: Boolean = false): Int {
        return when {
            isCompleted -> android.graphics.Color.GREEN
            infoType in 2..5 -> android.graphics.Color.rgb(63, 81, 181) // Indigo
            else -> if (infoType == 0 && !noHomework)
                android.graphics.Color.argb(128, 33, 150, 243) // Light Blue with 50% opacity
            else
                android.graphics.Color.rgb(33, 150, 243) // Light Blue
        }
    }

    val infotypeShortString: String?
        get() = arrayOf(null, "HW", "PW", "T", "SO", "MO", null, null)[infoType]
}