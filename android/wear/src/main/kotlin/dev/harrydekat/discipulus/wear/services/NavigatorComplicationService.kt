package dev.harrydekat.discipulus.wear.services

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.drawable.Icon
import android.util.Base64
import android.util.Log
import androidx.wear.watchface.complications.data.*
import androidx.wear.watchface.complications.datasource.ComplicationRequest
import androidx.wear.watchface.complications.datasource.SuspendingComplicationDataSourceService
import dev.harrydekat.discipulus.wear.R
import dev.harrydekat.discipulus.wear.WearAppActivity
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import java.io.ByteArrayInputStream
import java.io.ObjectInputStream
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class NavigatorComplicationService : SuspendingComplicationDataSourceService() {

    override suspend fun onComplicationRequest(request: ComplicationRequest): ComplicationData? {
        val nextEvent = getNextEvent(this)
        val tapAction = getTapAction(this)

        return when (request.complicationType) {
            ComplicationType.SHORT_TEXT -> {
                val text: String
                val title: String?

                if (nextEvent != null) {
                    text = nextEvent.location ?: (nextEvent.startHourIndicator?.let { "${it}e" } ?: nextEvent.name.take(4))
                    title = nextEvent.shortName ?: nextEvent.name.take(3)
                } else {
                    text = "Vrij"
                    title = null
                }

                ShortTextComplicationData.Builder(
                    text = PlainComplicationText.Builder(text).build(),
                    contentDescription = PlainComplicationText.Builder("Volgende les: ${nextEvent?.name ?: "Geen"}").build()
                ).apply {
                    if (title != null) {
                        setTitle(PlainComplicationText.Builder(title).build())
                    }
                    setTapAction(tapAction)
                    setMonochromaticImage(
                        MonochromaticImage.Builder(
                            image = Icon.createWithResource(this@NavigatorComplicationService, R.drawable.discipulus_complication_icon)
                        ).build()
                    )
                }.build()
            }

            ComplicationType.LONG_TEXT -> {
                val text: String
                val title: String?

                if (nextEvent != null) {
                    text = nextEvent.name
                    val timeFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
                    val timeStr = timeFormat.format(nextEvent.startTime)
                    title = if (!nextEvent.location.isNullOrEmpty()) {
                        "${nextEvent.location} · $timeStr"
                    } else {
                        timeStr
                    }
                } else {
                    text = "Geen lessen gepland"
                    title = "Vrij"
                }

                LongTextComplicationData.Builder(
                    text = PlainComplicationText.Builder(text).build(),
                    contentDescription = PlainComplicationText.Builder("Volgende les info").build()
                ).apply {
                    if (title != null) {
                        setTitle(PlainComplicationText.Builder(title).build())
                    }
                    setTapAction(tapAction)
                    setMonochromaticImage(
                        MonochromaticImage.Builder(
                            image = Icon.createWithResource(this@NavigatorComplicationService, R.drawable.discipulus_complication_icon)
                        ).build()
                    )
                }.build()
            }

            else -> null
        }
    }

    override fun getPreviewData(type: ComplicationType): ComplicationData? {
        val tapAction = getTapAction(this)
        return when (type) {
            ComplicationType.SHORT_TEXT -> {
                ShortTextComplicationData.Builder(
                    text = PlainComplicationText.Builder("103").build(),
                    contentDescription = PlainComplicationText.Builder("Voorbeeld").build()
                ).setTitle(PlainComplicationText.Builder("WIS").build())
                    .setTapAction(tapAction)
                    .build()
            }
            ComplicationType.LONG_TEXT -> {
                LongTextComplicationData.Builder(
                    text = PlainComplicationText.Builder("Wiskunde").build(),
                    contentDescription = PlainComplicationText.Builder("Voorbeeld").build()
                ).setTitle(PlainComplicationText.Builder("103 · 08:30").build())
                    .setTapAction(tapAction)
                    .build()
            }
            else -> null
        }
    }

    private fun getNextEvent(context: Context): ScheduleEvent? {
        val prefs = context.getSharedPreferences("discipulus_wear_prefs", Context.MODE_PRIVATE)
        val scheduleBase64 = prefs.getString("cached_schedule", null) ?: return null
        return try {
            val bytes = Base64.decode(scheduleBase64, Base64.DEFAULT)
            val bais = ByteArrayInputStream(bytes)
            val map = ObjectInputStream(bais).use { it.readObject() } as? Map<String, List<ScheduleEvent>>
            val now = Date()
            val allEvents = map?.values?.flatten()?.sortedBy { it.startTime } ?: emptyList()

            // 1. Return currently active event (excluding completed homework events)
            val current = allEvents.firstOrNull { 
                it.startTime.time <= now.time && it.endTime.time > now.time && !(it.isCompleted && it.infoType == 1) 
            }
            if (current != null) return current

            // 2. Return next upcoming event that is not completed
            allEvents.firstOrNull { it.startTime.after(now) && !(it.isCompleted && it.infoType == 1) }
        } catch (e: Exception) {
            Log.e("NavigatorComplication", "Error loading schedule for complication", e)
            null
        }
    }

    private fun getTapAction(context: Context): PendingIntent {
        val intent = Intent(context, WearAppActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val flags = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        return PendingIntent.getActivity(context, 0, intent, flags)
    }
}
