package dev.harrydekat.discipulus

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import com.istornz.live_activities.LiveActivityManager
import kotlin.math.ceil

class CustomLiveActivityManager(context: Context) : LiveActivityManager(context) {
    private val context: Context = context.applicationContext
    private val channelId = "Live Activities"
    private val notificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    private val handler = Handler(Looper.getMainLooper())

    private var latestData: Map<String, Any>? = null

    private val refreshRunnable = object : Runnable {
        override fun run() {
            refreshIfActive()
            handler.postDelayed(this, 30_000L)
        }
    }

    private val pendingIntent = PendingIntent.getActivity(
        context,
        200,
        Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("discipulus://calendar")
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        },
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    init {
        cleanOldNotifications()
    }

    private fun cleanOldNotifications() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                notificationManager.activeNotifications.forEach { sbn ->
                    val cId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        sbn.notification.channelId
                    } else null
                    if (cId == "discipulus_live_activities" || cId == "discipulus_live_activities_v2") {
                        notificationManager.cancel(sbn.tag, sbn.id)
                    }
                }
            }
        } catch (_: Exception) {}
    }

    private fun cancelAllLiveActivityNotifications() {
        handler.removeCallbacks(refreshRunnable)
        latestData = null
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                notificationManager.activeNotifications
                    .filter { sbn ->
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            sbn.notification.channelId == channelId ||
                            sbn.notification.channelId == "discipulus_live_activities" ||
                            sbn.notification.channelId == "discipulus_live_activities_v2"
                        } else true
                    }
                    .forEach { sbn ->
                        notificationManager.cancel(sbn.tag, sbn.id)
                    }
            }
        } catch (_: Exception) {}
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Delete old channels so they don't persist
            notificationManager.deleteNotificationChannel("discipulus_live_activities")
            notificationManager.deleteNotificationChannel("discipulus_live_activities_v2")

            val name = "Lopende lessen"
            val descriptionText = "Toont live informatie over de huidige les"
            // Promoted ongoing notifications require IMPORTANCE_DEFAULT or higher (never silent/LOW)
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(channelId, name, importance).apply {
                description = descriptionText
                setShowBadge(false)
                setSound(null, null) // Silent updates: no alert sound or buzzing on ticks
                enableVibration(false)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    override suspend fun buildNotification(
        notification: Notification.Builder,
        event: String,
        data: Map<String, Any>
    ): Notification {
        createNotificationChannel()
        latestData = data

        val isOngoing = (data["isOngoing"] as? Boolean) ?: true
        val nextStartMs = (data["nextStartTime"] as? Number)?.toLong() ?: 0L
        val now = System.currentTimeMillis()

        // Android specification: Pre-Event is HIDDEN (> 5m before start).
        if (!isOngoing && nextStartMs > 0L && now < nextStartMs - 5 * 60 * 1000L) {
            handler.removeCallbacks(refreshRunnable)
            // Immediately cancel the notification right after the superclass posts it
            handler.post {
                cancelAllLiveActivityNotifications()
            }
        } else {
            startAutoRefresh()
        }

        return populateNotification(notification, data).build()
    }

    private fun startAutoRefresh() {
        handler.removeCallbacks(refreshRunnable)
        handler.postDelayed(refreshRunnable, 30_000L)
    }

    private fun refreshIfActive() {
        val data = latestData ?: return
        val endMs = (data["endTime"] as? Number)?.toLong() ?: return
        val nextStartMs = (data["nextStartTime"] as? Number)?.toLong() ?: 0L
        val isOngoing = (data["isOngoing"] as? Boolean) ?: true
        val now = System.currentTimeMillis()

        // If in Android Pre-Event (> 5m before next start), dismiss immediately and stop
        if (!isOngoing && nextStartMs > 0L && now < nextStartMs - 5 * 60 * 1000L) {
            cancelAllLiveActivityNotifications()
            return
        }

        // If activity has ended, evaluate dismissal
        if (now > endMs + 60_000L) {
            // Dismiss if:
            // 1. No next lesson today (nextStartMs <= 0)
            // 2. Next lesson is more than 5 minutes away (pre-event is hidden on Android)
            // 3. Next lesson has already started (waiting for new schedule update)
            if (nextStartMs <= 0L || nextStartMs > now + 5 * 60 * 1000L || now >= nextStartMs) {
                cancelAllLiveActivityNotifications()
                return
            }
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val active = notificationManager.activeNotifications.find {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        it.notification.channelId == channelId ||
                        it.notification.channelId == "discipulus_live_activities" ||
                        it.notification.channelId == "discipulus_live_activities_v2"
                    } else {
                        true
                    }
                }
                if (active != null) {
                    @Suppress("DEPRECATION")
                    val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        Notification.Builder(context, channelId)
                    } else {
                        Notification.Builder(context)
                    }
                    val updatedNotification = populateNotification(builder, data).build()
                    notificationManager.notify(active.tag, active.id, updatedNotification)
                } else {
                    handler.removeCallbacks(refreshRunnable)
                }
            }
        } catch (_: Exception) {
            // Fail safely if activeNotifications cannot be inspected
        }
    }

    private fun populateNotification(
        builder: Notification.Builder,
        data: Map<String, Any>
    ): Notification.Builder {
        val title = (data["title"] as? String)?.takeIf { it.isNotBlank() } ?: "Les"
        val room = (data["room"] as? String) ?: ""
        val hourIndicator = (data["hourIndicator"] as? String) ?: ""
        val afterText = (data["afterText"] as? String) ?: ""
        val startMs = (data["startTime"] as? Number)?.toLong() ?: System.currentTimeMillis()
        val endMs = (data["endTime"] as? Number)?.toLong() ?: (startMs + 45 * 60 * 1000L)
        val nextTitle = (data["nextTitle"] as? String) ?: ""
        val nextRoom = (data["nextRoom"] as? String) ?: ""
        val nextStartMs = (data["nextStartTime"] as? Number)?.toLong() ?: 0L
        val isLastLesson = (data["isLastLesson"] as? Boolean) ?: false
        val isOngoing = (data["isOngoing"] as? Boolean) ?: true
        val nextDirectlyAfter = (data["nextDirectlyAfter"] as? Boolean) ?: false

        val duration = maxOf(1L, endMs - startMs)
        val defaultStartLate = startMs + (duration * 0.10).toLong()
        val defaultEndTransition = endMs - maxOf((duration * 0.10).toLong(), minOf(5 * 60 * 1000L, (duration * 0.25).toLong()))
        val startThreshold = (data["startLateThreshold"] as? Number)?.toLong() ?: defaultStartLate
        val endThreshold = (data["endTransitionThreshold"] as? Number)?.toLong() ?: defaultEndTransition

        val now = System.currentTimeMillis()

        val smallIcon: Int
        val shortCriticalText: String
        val contentTitle: String
        val subText: String
        val countdownTargetMs: Long

        if (!isOngoing) {
            // STATE 2: IMMINENT / PRE-EVENT / BREAK
            val targetRoom = nextRoom.ifEmpty { room }
            val destinationName = if (nextTitle.isNotEmpty()) nextTitle else title
            smallIcon = R.drawable.ic_live_activity_navigate
            shortCriticalText = formatLocation(targetRoom.ifEmpty { destinationName })

            contentTitle = title
            subText = if (title == "Pauze") "Pauze" else "Volgende les"
            countdownTargetMs = if (nextStartMs > 0) nextStartMs else endMs
        } else {
            // LESSON IS ONGOING
            // In the passing period (now >= endMs), count down to next lesson start if available
            countdownTargetMs = if (now >= endMs && nextStartMs > 0L) nextStartMs else endMs

            when {
                // STATE 3: LESSON START / LATE WINDOW (Start to +10%)
                now < startThreshold -> {
                    smallIcon = R.drawable.ic_live_activity_pin
                    shortCriticalText = formatLocation(room.ifEmpty { title })
                    contentTitle = title
                    subText = hourIndicator.ifEmpty { "Huidige les" }
                }

                // STATE 5: LESSON END WINDOW (Final 10% / ~5m)
                now >= endThreshold -> {
                    if (nextDirectlyAfter) {
                        smallIcon = R.drawable.ic_live_activity_navigate
                        shortCriticalText = formatLocation(nextRoom.ifEmpty { nextTitle.ifEmpty { "Vrij" } })
                        contentTitle = title
                        subText = if (isLastLesson) "Hierna vrij" else "Volgende les"
                    } else {
                        val remainingMs = maxOf(0L, endMs - now)
                        smallIcon = R.drawable.ic_live_activity_pin
                        shortCriticalText = formatTimeRemaining(remainingMs)
                        contentTitle = title
                        subText = hourIndicator.ifEmpty { "Huidige les" }
                    }
                }

                // STATE 4: LESSON MID-PERIOD (+10% to End Window)
                else -> {
                    val remainingMs = maxOf(0L, endMs - now)
                    smallIcon = R.drawable.ic_live_activity_pin
                    shortCriticalText = formatTimeRemaining(remainingMs)
                    contentTitle = title
                    subText = hourIndicator.ifEmpty { "Huidige les" }
                }
            }
        }

        val locationDetails = listOf(
            if (room.isNotEmpty()) "Lokaal $room" else "",
            if (isOngoing && hourIndicator.isNotEmpty()) hourIndicator else ""
        ).filter { it.isNotEmpty() }.joinToString(" • ")

        val contentText = locationDetails.ifEmpty { afterText }

        val expandedLines = listOf(
            locationDetails,
            afterText
        ).filter { it.isNotEmpty() }.joinToString("\n")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId(channelId)
        }

        // Live Update / Promoted Ongoing Notification flags
        builder.extras.putBoolean("android.requestPromotedOngoing", true)

        builder
            .setSmallIcon(smallIcon)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setContentTitle(contentTitle)
            .setContentText(contentText)
            .setSubText(subText)
            .setContentIntent(pendingIntent)
            .setShowWhen(true)
            .setWhen(countdownTargetMs)
            .setUsesChronometer(true)
            .setCategory(Notification.CATEGORY_EVENT)
            .setVisibility(Notification.VISIBILITY_PUBLIC)

        if (expandedLines.isNotEmpty()) {
            builder.setStyle(Notification.BigTextStyle().bigText(expandedLines))
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            builder.setChronometerCountDown(true)
        }

        if (Build.VERSION.SDK_INT >= 36) {
            builder.setShortCriticalText(shortCriticalText)
            try {
                // Notification.FLAG_PROMOTED_ONGOING = 0x40000 = 262144
                builder.setFlag(262144, true)
            } catch (_: Exception) {}
        }

        return builder
    }

    private fun formatLocation(location: String): String {
        val trimmed = location.trim()
        val truncated = if (trimmed.length > 7) trimmed.take(7).trim() else trimmed
        return truncated.ifEmpty { "Les" }
    }

    private fun formatTimeRemaining(remainingMs: Long): String {
        if (remainingMs <= 0L) return "0m"
        val totalMinutes = maxOf(1L, ceil(remainingMs / 60000.0).toLong())
        return when {
            totalMinutes < 60 -> "${totalMinutes}m"
            else -> {
                val hours = totalMinutes / 60
                val mins = totalMinutes % 60
                if (mins == 0L) "${hours}u" else "${hours}u${mins}m"
            }
        }
    }
}