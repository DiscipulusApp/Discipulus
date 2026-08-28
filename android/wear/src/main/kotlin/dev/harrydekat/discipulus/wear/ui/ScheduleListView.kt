package dev.harrydekat.discipulus.wear.ui

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun ScheduleListView(
    viewModel: WearViewModel,
    onNavigateToEventDetail: () -> Unit = {}
) {
    val schedule by viewModel.schedule.collectAsState()
    val showCancelledLessons by viewModel.showCancelledLessons.collectAsState()
    val showBreakSeparators by viewModel.showBreakSeparators.collectAsState()
    val eventTimeDisplay by viewModel.eventTimeDisplay.collectAsState()
    val scheduleViewMode by viewModel.scheduleViewMode.collectAsState()
    val lastUpdate by viewModel.lastUpdate.collectAsState()

    val visibleSchedule = remember(schedule, showCancelledLessons) {
        schedule.mapValues { (_, events) ->
            if (showCancelledLessons) events else events.filterNot { it.status in 4..5 || it.isCanceled }
        }
    }

    LaunchedEffect(Unit) {
        viewModel.requestSchedule()
    }

    if (visibleSchedule.isEmpty() || visibleSchedule.values.all { it.isEmpty() }) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text(
                "Geen afspraken",
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodySmall,
                textAlign = TextAlign.Center
            )
        }
    } else if (scheduleViewMode == 1) {
        // Day-by-day horizontal pager
        val sortedDates = remember(visibleSchedule) { visibleSchedule.keys.sorted() }
        val todayStr = remember { SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date()) }
        val initialPage = remember(sortedDates) {
            val idx = sortedDates.indexOf(todayStr)
            if (idx >= 0) idx else 0
        }
        val pagerState = rememberPagerState(initialPage = initialPage, pageCount = { sortedDates.size })

        HorizontalPager(
            state = pagerState,
            modifier = Modifier.fillMaxSize()
        ) { page ->
            val dateKey = sortedDates[page]
            val events = visibleSchedule[dateKey] ?: emptyList()

            val dayTargetIndex = remember(events, showBreakSeparators) {
                val now = System.currentTimeMillis()
                var currentIdx = 1 // After Date header (index 0)
                var target: Int? = null
                for (i in events.indices) {
                    val ev = events[i]
                    if (target == null && ev.endTime.time > now) {
                        target = currentIdx
                    }
                    currentIdx++
                    if (showBreakSeparators && i < events.size - 1) {
                        val nextEvent = events[i + 1]
                        val gapMs = nextEvent.startTime.time - ev.endTime.time
                        val gapMinutes = (gapMs / (1000 * 60)).toInt()
                        if (gapMinutes >= 5) {
                            currentIdx++
                        }
                    }
                }
                target ?: 0
            }

            val listState = rememberScalingLazyListState(initialCenterItemIndex = dayTargetIndex)

            LaunchedEffect(dayTargetIndex) {
                if (dayTargetIndex > 0) {
                    listState.scrollToItem(dayTargetIndex)
                }
            }

            ScreenScaffold(scrollState = listState) {
                ScalingLazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    state = listState
                ) {
                    item {
                        Text(
                            text = formatDateHeader(dateKey),
                            style = MaterialTheme.typography.titleSmall,
                            color = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.padding(bottom = 4.dp, top = 8.dp)
                        )
                    }

                    if (events.isEmpty()) {
                        item {
                            Text(
                                "Vrij",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.padding(vertical = 8.dp)
                            )
                        }
                    } else {
                        events.forEachIndexed { index, event ->
                            item {
                                EventCard(
                                    event = event,
                                    eventTimeDisplay = eventTimeDisplay,
                                    onClick = {
                                        viewModel.selectEvent(event)
                                        onNavigateToEventDetail()
                                    }
                                )
                            }

                            if (showBreakSeparators && index < events.size - 1) {
                                val nextEvent = events[index + 1]
                                val gapMs = nextEvent.startTime.time - event.endTime.time
                                val gapMinutes = (gapMs / (1000 * 60)).toInt()
                                if (gapMinutes >= 5) {
                                    item {
                                        BreakRow(durationMinutes = gapMinutes)
                                    }
                                }
                            }
                        }
                    }

                    item {
                        LastUpdateFooter(lastUpdate = lastUpdate)
                    }
                }
            }
        }
    } else {
        // Continuous vertical list
        val sortedDates = remember(visibleSchedule) { visibleSchedule.keys.sorted() }

        val targetIndex = remember(visibleSchedule, sortedDates, showBreakSeparators) {
            val now = System.currentTimeMillis()
            var currentIdx = 1 // After "Rooster" title (index 0)
            var target: Int? = null
            var firstTodayHeaderIdx: Int? = null
            val todayStr = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(Date())

            for (dateKey in sortedDates) {
                val headerIdx = currentIdx
                if (dateKey == todayStr && firstTodayHeaderIdx == null) {
                    firstTodayHeaderIdx = headerIdx
                }
                currentIdx++ // For date header

                val events = visibleSchedule[dateKey] ?: emptyList()
                if (events.isEmpty()) {
                    currentIdx++ // For "Vrij"
                } else {
                    for (i in events.indices) {
                        val ev = events[i]
                        if (target == null && ev.endTime.time > now) {
                            target = currentIdx
                        }
                        currentIdx++ // For EventCard

                        if (showBreakSeparators && i < events.size - 1) {
                            val nextEvent = events[i + 1]
                            val gapMs = nextEvent.startTime.time - ev.endTime.time
                            val gapMinutes = (gapMs / (1000 * 60)).toInt()
                            if (gapMinutes >= 5) {
                                currentIdx++ // For BreakRow
                            }
                        }
                    }
                }
            }
            target ?: firstTodayHeaderIdx ?: 0
        }

        val listState = rememberScalingLazyListState(initialCenterItemIndex = targetIndex)

        LaunchedEffect(targetIndex) {
            if (targetIndex > 0) {
                listState.scrollToItem(targetIndex)
            }
        }

        ScreenScaffold(scrollState = listState) {
            ScalingLazyColumn(
                modifier = Modifier.fillMaxSize(),
                state = listState
            ) {
                item {
                    Text(
                        text = "Rooster",
                        style = MaterialTheme.typography.titleSmall,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.padding(bottom = 4.dp)
                    )
                }

                sortedDates.forEach { dateKey ->
                    item {
                        Text(
                            text = formatDateHeader(dateKey),
                            style = MaterialTheme.typography.labelSmall.copy(fontWeight = FontWeight.Bold),
                            color = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.padding(top = 10.dp, bottom = 4.dp)
                        )
                    }

                    val events = visibleSchedule[dateKey] ?: emptyList()
                    if (events.isEmpty()) {
                        item {
                            Text(
                                "Vrij",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                modifier = Modifier.padding(vertical = 4.dp)
                            )
                        }
                    } else {
                        events.forEachIndexed { index, event ->
                            item {
                                EventCard(
                                    event = event,
                                    eventTimeDisplay = eventTimeDisplay,
                                    onClick = {
                                        viewModel.selectEvent(event)
                                        onNavigateToEventDetail()
                                    }
                                )
                            }

                            if (showBreakSeparators && index < events.size - 1) {
                                val nextEvent = events[index + 1]
                                val gapMs = nextEvent.startTime.time - event.endTime.time
                                val gapMinutes = (gapMs / (1000 * 60)).toInt()
                                if (gapMinutes >= 5) {
                                    item {
                                        BreakRow(durationMinutes = gapMinutes)
                                    }
                                }
                            }
                        }
                    }
                }

                item {
                    LastUpdateFooter(lastUpdate = lastUpdate)
                }
            }
        }
    }
}

@Composable
fun BreakRow(durationMinutes: Int) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp, horizontal = 12.dp)
            .border(
                width = 1.dp,
                color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.3f),
                shape = RoundedCornerShape(12.dp)
            )
            .padding(vertical = 4.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = "$durationMinutes m pauze",
            style = MaterialTheme.typography.bodySmall.copy(
                color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f),
                fontSize = 10.sp
            ),
            textAlign = TextAlign.Center
        )
    }
}

@Composable
fun EventCard(event: ScheduleEvent, eventTimeDisplay: Int = 0, onClick: () -> Unit) {
    val isCompleted = event.isCompleted && event.infoType == 1
    val isCanceled = event.status in 4..5 || event.isCanceled

    val containerColor = when {
        isCanceled -> MaterialTheme.colorScheme.errorContainer.copy(alpha = 0.5f)
        isCompleted -> MaterialTheme.colorScheme.secondaryContainer
        event.infoType in 2..5 -> MaterialTheme.colorScheme.tertiaryContainer.copy(alpha = 0.7f)
        else -> MaterialTheme.colorScheme.surfaceContainer
    }
    val contentColor = when {
        isCanceled -> MaterialTheme.colorScheme.onErrorContainer
        isCompleted -> MaterialTheme.colorScheme.onSecondaryContainer
        event.infoType in 2..5 -> MaterialTheme.colorScheme.onTertiaryContainer
        else -> MaterialTheme.colorScheme.onSurface
    }

    val hasDoubleHour = event.endHourIndicator != null && event.startHourIndicator != event.endHourIndicator
    val cardHeight = if (hasDoubleHour) 60.dp else 48.dp

    Card(
        onClick = onClick,
        modifier = Modifier
            .fillMaxWidth()
            .height(cardHeight)
            .padding(vertical = 1.dp),
        colors = CardDefaults.cardColors(
            containerColor = containerColor,
            contentColor = contentColor
        ),
        contentPadding = PaddingValues(horizontal = 8.dp, vertical = 2.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxSize(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Leading Hour Indicator circular badge
            if (event.startHourIndicator != null) {
                val badgeBgColor = when {
                    isCanceled -> MaterialTheme.colorScheme.error
                    isCompleted -> MaterialTheme.colorScheme.secondary
                    event.infoType in 2..5 -> MaterialTheme.colorScheme.tertiary
                    else -> MaterialTheme.colorScheme.onSurface.copy(alpha = 0.15f)
                }
                val badgeTextColor = when {
                    isCanceled -> MaterialTheme.colorScheme.onError
                    isCompleted -> MaterialTheme.colorScheme.onSecondary
                    event.infoType in 2..5 -> MaterialTheme.colorScheme.onTertiary
                    else -> MaterialTheme.colorScheme.onSurface
                }

                Box(
                    modifier = Modifier
                        .size(28.dp)
                        .background(
                            color = badgeBgColor,
                            shape = CircleShape
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    val hourText = if (event.endHourIndicator != null && event.startHourIndicator != event.endHourIndicator) {
                        "${event.startHourIndicator}/${event.endHourIndicator}"
                    } else {
                        "${event.startHourIndicator}"
                    }
                    Text(
                        text = hourText,
                        style = MaterialTheme.typography.labelMedium.copy(
                            fontWeight = FontWeight.Bold,
                            color = badgeTextColor,
                            fontSize = 11.sp
                        )
                    )
                }
                Spacer(modifier = Modifier.width(6.dp))
            }

            // Title & Location / Time / HW abbreviations
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = event.name,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    style = MaterialTheme.typography.labelMedium.copy(
                        textDecoration = if (isCanceled) TextDecoration.LineThrough else TextDecoration.None
                    )
                )

                val shortInfo = when (event.infoType) {
                    1 -> "HW"
                    2 -> "PW"
                    3 -> "T"
                    4 -> "SO"
                    5 -> "MO"
                    6 -> "Inf"
                    7 -> "Not"
                    else -> null
                }

                val timeFormat = remember { SimpleDateFormat("HH:mm", Locale.getDefault()) }
                val timeStr = when (eventTimeDisplay) {
                    1 -> timeFormat.format(event.startTime)
                    2 -> "${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}"
                    else -> null
                }

                val subtitleParts = mutableListOf<String>()
                if (!event.location.isNullOrEmpty()) {
                    subtitleParts.add(event.location)
                }
                if (timeStr != null) {
                    subtitleParts.add(timeStr)
                }

                if (subtitleParts.isNotEmpty() || shortInfo != null || isCanceled) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        if (subtitleParts.isNotEmpty()) {
                            Text(
                                text = subtitleParts.joinToString(" · "),
                                style = MaterialTheme.typography.bodySmall,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                                modifier = Modifier.weight(1f, fill = false)
                            )
                        }

                        if (shortInfo != null) {
                            val accentColor = if (isCompleted) {
                                MaterialTheme.colorScheme.secondary
                            } else if (event.infoType in 2..5) {
                                MaterialTheme.colorScheme.tertiary
                            } else {
                                MaterialTheme.colorScheme.primary
                            }

                            Text(
                                text = if (subtitleParts.isNotEmpty()) "• $shortInfo" else shortInfo,
                                style = MaterialTheme.typography.bodySmall.copy(
                                    fontWeight = FontWeight.Bold,
                                    color = accentColor
                                )
                            )
                        }

                        if (isCanceled) {
                            Text(
                                text = if (subtitleParts.isNotEmpty() || shortInfo != null) "• Uitgevallen" else "Uitgevallen",
                                style = MaterialTheme.typography.bodySmall.copy(
                                    color = MaterialTheme.colorScheme.error,
                                    fontWeight = FontWeight.Bold
                                )
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun LastUpdateFooter(lastUpdate: java.util.Date?) {
    lastUpdate?.let {
        val timeFormat = remember { SimpleDateFormat("HH:mm", Locale.getDefault()) }
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 12.dp, horizontal = 8.dp),
            horizontalArrangement = Arrangement.Center
        ) {
            Text(
                text = "Laatst bijgewerkt: ${timeFormat.format(it)}",
                style = MaterialTheme.typography.bodySmall.copy(fontSize = 9.sp),
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center
            )
        }
    }
}

private fun formatDateHeader(key: String): String {
    return try {
        val formatIn = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val date = formatIn.parse(key) ?: return key
        val formatOut = SimpleDateFormat("EEEE d MMM", Locale("nl", "NL"))
        formatOut.format(date).replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
    } catch (e: Exception) { key }
}
