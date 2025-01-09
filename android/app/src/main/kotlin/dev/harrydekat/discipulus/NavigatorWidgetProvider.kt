package dev.harrydekat.discipulus

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.graphics.PorterDuff
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.util.Log
import android.widget.RemoteViews
import androidx.core.graphics.drawable.toBitmap
import org.json.JSONArray
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.*

class NavigatorWidgetProvider : HomeWidgetProvider() {

    override fun onAppWidgetOptionsChanged(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, newOptions: Bundle) {
        val widgetWidth = newOptions.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val widgetHeight = newOptions.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

        val views = when {
            widgetWidth >= 250 && widgetHeight >= 100 -> updateMediumWidget(context, loadEvents(context, HomeWidgetPlugin.getData(context)), Date())
            widgetWidth >= 180 && widgetHeight >= 50 -> updateRectangularWidget(context, loadEvents(context, HomeWidgetPlugin.getData(context)), Date())
            else -> updateSmallWidget(context, loadEvents(context, HomeWidgetPlugin.getData(context)), Date())
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        for (appWidgetId in appWidgetIds) {
            val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
            onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, options)
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, sharedPreferences: SharedPreferences) {
        val widgetInfo = appWidgetManager.getAppWidgetInfo(appWidgetId)
        val events = loadEvents(context, sharedPreferences)
        val currentDate = Date()

        val views = when (widgetInfo.initialLayout) {
            R.layout.widget_small -> updateSmallWidget(context, events, currentDate)
            R.layout.widget_medium -> updateMediumWidget(context, events, currentDate)
            R.layout.widget_rectangular -> updateRectangularWidget(context, events, currentDate)
            else -> null
        }

        views?.let {
            appWidgetManager.updateAppWidget(appWidgetId, it)
        }
    }

    private fun updateSmallWidget(context: Context, events: List<Event>, currentDate: Date): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_small)
        val currentEvent = events.firstOrNull { it.startTime <= currentDate.time && it.endTime > currentDate.time }

        if (currentEvent != null) {
            views.setTextViewText(R.id.event_location, currentEvent.location ?: "Geen locatie")
            views.setTextViewText(R.id.event_name, currentEvent.name)
            views.setTextViewText(R.id.event_time, DateUtils.formatTime(Date(currentEvent.startTime)))
            views.setTextColor(R.id.event_location, currentEvent.infotypeColor(true))
        } else {
            views.setTextViewText(R.id.event_location, "Geen lessen vandaag")
            views.setTextViewText(R.id.event_name, "")
            views.setTextViewText(R.id.event_time, "")
        }

        val nextEvent = events.firstOrNull { it.startTime > currentDate.time }
        if (nextEvent != null) {
            views.setTextViewText(R.id.next_event, "${nextEvent.name} ${DateUtils.formatDate(nextEvent.startTime - currentDate.time)}")
        } else {
            views.setTextViewText(R.id.next_event, "Geen volgende les")
        }

        return views
    }

    private fun updateMediumWidget(context: Context, events: List<Event>, currentDate: Date): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_medium)

        // Update the small widget part
        val currentEvent = events.firstOrNull { it.startTime <= currentDate.time && it.endTime > currentDate.time }
        if (currentEvent != null) {
            views.setTextViewText(R.id.event_location, currentEvent.location ?: "Geen locatie")
            views.setTextViewText(R.id.event_name, currentEvent.name)
            views.setTextViewText(R.id.event_time, DateUtils.formatTime(Date(currentEvent.startTime)))
            views.setTextColor(R.id.event_location, currentEvent.infotypeColor(true))
        } else {
            views.setTextViewText(R.id.event_location, "Geen lessen vandaag")
            views.setTextViewText(R.id.event_name, "")
            views.setTextViewText(R.id.event_time, "")
        }

        // Update the upcoming events list
        val upcomingEvents = events.filter { it.startTime > currentDate.time }.take(3)
        for (i in 0 until 3) {
            val event = upcomingEvents.getOrNull(i)
            if (event != null) {
                views.setTextViewText(context.resources.getIdentifier("upcoming_event_${i + 1}", "id", context.packageName), "${event.name} ${DateUtils.formatDate(event.startTime - currentDate.time)}")
                views.setViewVisibility(context.resources.getIdentifier("upcoming_event_${i + 1}", "id", context.packageName), android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(context.resources.getIdentifier("upcoming_event_${i + 1}", "id", context.packageName), android.view.View.GONE)
            }
        }

        return views
    }

    private fun updateRectangularWidget(context: Context, events: List<Event>, currentDate: Date): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_rectangular)
        val upcomingEvent = events.firstOrNull { it.startTime > currentDate.time }

        if (upcomingEvent != null) {
            views.setTextViewText(R.id.location_circle, upcomingEvent.location?.take(4) ?: "")
            views.setTextViewText(R.id.event_name, upcomingEvent.name)
            views.setTextViewText(R.id.event_time, DateUtils.formatDate(upcomingEvent.startTime - currentDate.time))

            // Set background color for location circle
            val backgroundDrawable: Drawable = context.resources.getDrawable(R.drawable.circle_background, null)
            backgroundDrawable.setColorFilter(upcomingEvent.infotypeColor(), PorterDuff.Mode.SRC_IN)
            views.setImageViewBitmap(R.id.location_circle, backgroundDrawable.constantState!!.newDrawable().mutate().toBitmap())
        } else {
            views.setTextViewText(R.id.location_circle, "🎉")
            views.setTextViewText(R.id.event_name, "Geen lessen gevonden")
            views.setTextViewText(R.id.event_time, "")
        }

        return views
    }

    private fun loadEvents(context: Context, sharedPreferences: SharedPreferences): List<Event> {
        val eventsJson = sharedPreferences.getString("events", "[]")
        val eventsArray = JSONArray(eventsJson)
        val events = mutableListOf<Event>()

        Log.d("NavigatorWidget", "${sharedPreferences.all}")
        Log.d("NavigatorWidget", "Loaded events JSON: $eventsJson")

        for (i in 0 until eventsArray.length()) {
            val eventObject = eventsArray.getJSONObject(i)
            events.add(
                Event(
                    id = eventObject.getInt("id"),
                    name = eventObject.getString("name"),
                    shortName = eventObject.optString("shortName"),
                    location = eventObject.optString("location"),
                    infoType = eventObject.getInt("infoType"),
                    startHourIndicator = eventObject.optInt("startHourIndicator"),
                    endHourIndicator = eventObject.optInt("endHourIndicator"),
                    startTime = eventObject.getLong("startTime"),
                    endTime = eventObject.getLong("endTime"),
                    isCompleted = eventObject.getBoolean("isCompleted")
                )
            )
        }

        return events
    }
}