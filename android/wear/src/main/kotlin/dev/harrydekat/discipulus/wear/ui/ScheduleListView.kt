package dev.harrydekat.discipulus.wear.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel
import java.text.SimpleDateFormat
import java.util.Locale

@Composable
fun ScheduleListView(viewModel: WearViewModel) {
    val schedule by viewModel.schedule.collectAsState()
    val showBreakSeparators by viewModel.showBreakSeparators.collectAsState()
    val lastUpdate by viewModel.lastUpdate.collectAsState()
    val listState = rememberScalingLazyListState()

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState
        ) {
            if (schedule.isEmpty()) {
                item {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Text(
                            "Geen afspraken",
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            style = MaterialTheme.typography.bodySmall,
                            textAlign = TextAlign.Center
                        )
                    }
                }
            } else {
                val sortedDates = schedule.keys.sorted()
                sortedDates.forEach { dateKey ->
                    item {
                        Text(
                            text = formatDateHeader(dateKey),
                            style = MaterialTheme.typography.titleSmall,
                            color = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.padding(bottom = 4.dp, top = 8.dp)
                        )
                    }

                    val events = schedule[dateKey] ?: emptyList()
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
                                    onClick = { viewModel.toggleEventCompletion(event.id) }
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
            }
            if (schedule.isNotEmpty()) {
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
fun EventCard(event: ScheduleEvent, onClick: () -> Unit) {
    // Only treat the event as completed if it is actually a homework task (infoType == 1)
    val isCompleted = event.isCompleted && event.infoType == 1

    val containerColor = if (isCompleted) {
        MaterialTheme.colorScheme.secondaryContainer // Themed completed container
    } else {
        when (event.infoType) {
            in 2..5 -> MaterialTheme.colorScheme.tertiaryContainer.copy(alpha = 0.7f)
            else -> MaterialTheme.colorScheme.surfaceContainer
        }
    }
    val contentColor = if (isCompleted) {
        MaterialTheme.colorScheme.onSecondaryContainer
    } else {
        when (event.infoType) {
            in 2..5 -> MaterialTheme.colorScheme.onTertiaryContainer
            else -> MaterialTheme.colorScheme.onSurface
        }
    }

    val hasDoubleHour = event.endHourIndicator != null && event.startHourIndicator != event.endHourIndicator
    val cardHeight = if (hasDoubleHour) 60.dp else 48.dp

    Card(
        onClick = { if (event.infoType == 1) onClick() },
        modifier = Modifier
            .fillMaxWidth()
            .height(cardHeight)
            .padding(vertical = 1.dp), // Less margin between items
        colors = CardDefaults.cardColors(
            containerColor = containerColor,
            contentColor = contentColor
        ),
        contentPadding = PaddingValues(horizontal = 8.dp, vertical = 2.dp) // Tight padding inside card
    ) {
        Row(
            modifier = Modifier.fillMaxSize(), // Fill available card height to center content vertically
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Leading Hour Indicator circular badge
            if (event.startHourIndicator != null) {
                val badgeBgColor = if (isCompleted) {
                    MaterialTheme.colorScheme.secondary // Themed completed badge
                } else if (event.infoType in 2..5) {
                    MaterialTheme.colorScheme.tertiary // Themed tertiary badge
                } else {
                    MaterialTheme.colorScheme.onSurface.copy(alpha = 0.15f) // Themed grey badge
                }
                val badgeTextColor = if (isCompleted) {
                    MaterialTheme.colorScheme.onSecondary
                } else if (event.infoType in 2..5) {
                    MaterialTheme.colorScheme.onTertiary
                } else {
                    MaterialTheme.colorScheme.onSurface
                }

                Box(
                    modifier = Modifier
                        .size(28.dp) // More compact badge (from 32.dp to 28.dp)
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
                Spacer(modifier = Modifier.width(6.dp)) // Tighter spacer
            }

            // Title & Location / HW abbreviations
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = event.name,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    style = MaterialTheme.typography.labelMedium
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

                // Conditionally render the subtitle row to prevent empty elements from taking vertical space
                if (!event.location.isNullOrEmpty() || shortInfo != null) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        if (!event.location.isNullOrEmpty()) {
                            Text(
                                text = event.location,
                                style = MaterialTheme.typography.bodySmall,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                        }

                        if (shortInfo != null) {
                            val accentColor = if (isCompleted) {
                                MaterialTheme.colorScheme.secondary // Themed completed type indicator
                            } else if (event.infoType in 2..5) {
                                MaterialTheme.colorScheme.tertiary
                            } else {
                                MaterialTheme.colorScheme.primary
                            }

                            Text(
                                text = "• $shortInfo",
                                style = MaterialTheme.typography.bodySmall.copy(
                                    fontWeight = FontWeight.Bold,
                                    color = accentColor
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
