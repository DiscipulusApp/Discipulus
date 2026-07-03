package dev.harrydekat.discipulus.wear.receivers

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Vibrator
import android.os.VibrationEffect
import androidx.core.app.NotificationCompat
import dev.harrydekat.discipulus.wear.WearAppActivity

class WearReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val eventId = intent.getIntExtra("event_id", -1)
        val eventName = intent.getStringExtra("event_name") ?: "Les"
        val eventLocation = intent.getStringExtra("event_location") ?: "Onbekende locatie"
        val offset = intent.getIntExtra("offset", 5)

        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "discipulus_wear_reminders"

        val channel = NotificationChannel(
            channelId,
            "Les Herinneringen",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Meldingen voor aankomende lessen"
            enableVibration(true)
        }
        notificationManager.createNotificationChannel(channel)

        val activityIntent = Intent(context, WearAppActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            context,
            eventId,
            activityIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("Volgende les: $eventName")
            .setContentText("Over $offset minuten in $eventLocation")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setVibrate(longArrayOf(0, 500, 200, 500))
            .build()

        notificationManager.notify(eventId, notification)

        try {
            val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            if (vibrator != null && vibrator.hasVibrator()) {
                vibrator.vibrate(VibrationEffect.createWaveform(longArrayOf(0, 500, 200, 500), -1))
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
