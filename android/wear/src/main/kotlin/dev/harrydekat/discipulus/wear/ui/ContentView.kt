package dev.harrydekat.discipulus.wear.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.material3.*
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Numbers
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Warning
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel

@Composable
fun ContentView(
    viewModel: WearViewModel,
    onNavigateToSchedule: () -> Unit,
    onNavigateToGrades: () -> Unit,
    onNavigateToSettings: () -> Unit
) {
    val schedule by viewModel.schedule.collectAsState()
    val schoolyears by viewModel.schoolyears.collectAsState()
    val currentEvent by viewModel.currentEvent.collectAsState()

    val hasData = schedule.isNotEmpty() || schoolyears.isNotEmpty()

    val listState = rememberScalingLazyListState()

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState
        ) {
            if (hasData) {
                item {
                    Text(
                        text = "Discipulus",
                        style = MaterialTheme.typography.titleSmall,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.padding(bottom = 4.dp)
                    )
                }

                currentEvent?.let { event ->
                    item {
                        CurrentLessonTile(event = event, onClick = onNavigateToSchedule)
                    }
                    item {
                        Spacer(modifier = Modifier.height(4.dp))
                    }
                }

                // Rooster button
                item {
                    Button(
                        onClick = onNavigateToSchedule,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Icon(
                                Icons.Default.DateRange,
                                contentDescription = "Rooster",
                                modifier = Modifier.size(18.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Column {
                                Text("Rooster", style = MaterialTheme.typography.labelMedium)
                                Text("De dagplanning", style = MaterialTheme.typography.bodySmall)
                            }
                        }
                    }
                }

                // Cijfers button
                item {
                    Button(
                        onClick = onNavigateToGrades,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Icon(
                                Icons.Default.Numbers,
                                contentDescription = "Cijfers",
                                modifier = Modifier.size(18.dp)
                            )
                            Spacer(modifier = Modifier.width(8.dp))
                            Column {
                                Text("Cijfers", style = MaterialTheme.typography.labelMedium)
                                Text("Laatste resultaten", style = MaterialTheme.typography.bodySmall)
                            }
                        }
                    }
                }

                item {
                    Spacer(modifier = Modifier.height(6.dp))
                }

                item {
                    Row(
                        horizontalArrangement = Arrangement.Center,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        FilledTonalButton(
                            onClick = onNavigateToSettings,
                            modifier = Modifier.size(44.dp)
                        ) {
                            Icon(
                                Icons.Default.Settings,
                                contentDescription = "Instellingen",
                                modifier = Modifier.size(18.dp)
                            )
                        }

                        Spacer(modifier = Modifier.width(12.dp))

                        Button(
                            onClick = { viewModel.refreshAll() },
                            modifier = Modifier.size(44.dp)
                        ) {
                            Icon(
                                Icons.Default.Refresh,
                                contentDescription = "Vernieuwen",
                                modifier = Modifier.size(18.dp)
                            )
                        }
                    }
                }
            } else {
                item {
                    Column(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            Icons.Default.Warning,
                            contentDescription = "Geen gegevens",
                            modifier = Modifier.size(32.dp),
                            tint = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Geen gegevens", style = MaterialTheme.typography.titleSmall)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            "Nog niet gesynchroniseerd.",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            textAlign = TextAlign.Center
                        )
                        Spacer(modifier = Modifier.height(12.dp))
                        Button(
                            onClick = { viewModel.refreshAll() },
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Text("Probeer opnieuw", style = MaterialTheme.typography.labelMedium)
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun CurrentLessonTile(
    event: ScheduleEvent,
    onClick: () -> Unit
) {
    val now = java.util.Date().time
    val isCurrent = event.startTime.time <= now && event.endTime.time > now
    val timeFormatter = remember { java.text.SimpleDateFormat("HH:mm", java.util.Locale.getDefault()) }

    val isCompleted = event.isCompleted && event.infoType == 1

    val containerColor = if (isCompleted) {
        MaterialTheme.colorScheme.secondaryContainer
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

    val extensionBgColor = if (isCompleted) {
        MaterialTheme.colorScheme.secondary
    } else if (event.infoType in 2..5) {
        MaterialTheme.colorScheme.tertiary
    } else {
        if (isCurrent) {
            MaterialTheme.colorScheme.primary
        } else {
            MaterialTheme.colorScheme.primaryContainer
        }
    }
    val extensionTextColor = if (isCompleted) {
        MaterialTheme.colorScheme.onSecondary
    } else if (event.infoType in 2..5) {
        MaterialTheme.colorScheme.onTertiary
    } else {
        if (isCurrent) {
            MaterialTheme.colorScheme.onPrimary
        } else {
            MaterialTheme.colorScheme.onPrimaryContainer
        }
    }

    val extensionText = if (isCurrent) {
        val remaining = ((event.endTime.time - now) / 60000).toInt().coerceAtLeast(1)
        "$remaining min. resterend"
    } else {
        val until = ((event.startTime.time - now) / 60000).toInt().coerceAtLeast(1)
        "Over $until min."
    }

    val badgeBgColor = if (isCompleted) {
        MaterialTheme.colorScheme.secondary
    } else if (event.infoType in 2..5) {
        MaterialTheme.colorScheme.tertiary
    } else {
        MaterialTheme.colorScheme.onSurface.copy(alpha = 0.15f)
    }
    val badgeTextColor = if (isCompleted) {
        MaterialTheme.colorScheme.onSecondary
    } else if (event.infoType in 2..5) {
        MaterialTheme.colorScheme.onTertiary
    } else {
        MaterialTheme.colorScheme.onSurface
    }

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

    val accentColor = if (isCompleted) {
        MaterialTheme.colorScheme.secondary
    } else if (event.infoType in 2..5) {
        MaterialTheme.colorScheme.tertiary
    } else {
        MaterialTheme.colorScheme.primary
    }

    Column(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(2.dp)
    ) {
        // 1. Top time indicator card
        Card(
            onClick = onClick,
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = extensionBgColor,
                contentColor = extensionTextColor
            ),
            contentPadding = PaddingValues(all = 0.dp)
        ) {
            Column(
                modifier = Modifier.fillMaxWidth(),
            ) {
                Box(
                        modifier = Modifier.fillMaxWidth().height(22.dp),
                        contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = extensionText,
                        style = MaterialTheme.typography.labelSmall.copy(
                            fontSize = 9.sp,
                            fontWeight = FontWeight.Bold
                        ),
                        color = extensionTextColor
                    )
                }


                 // 2. Main Event Card (matching Calendar event layout)
                Card(
                    onClick = onClick,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(48.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = containerColor,
                        contentColor = contentColor
                    ),
                    contentPadding = PaddingValues(horizontal = 10.dp, vertical = 2.dp)

                ) {
                    Row(
                        modifier = Modifier.fillMaxSize(),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // Leading hour badge indicator
                        if (event.startHourIndicator != null) {
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

                        // Name, time, location & type info
                        Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.Center) {
                            Text(
                                text = event.name,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                                style = MaterialTheme.typography.labelMedium
                            )

                            // Subtitle containing Location, formatted Time slot, and optional Type abbreviation
                            val timeStr = "${timeFormatter.format(event.startTime)} - ${timeFormatter.format(event.endTime)}"
                            val subtitleParts = mutableListOf<String>()
                            if (!event.location.isNullOrEmpty()) subtitleParts.add(event.location)
                            subtitleParts.add(timeStr)
                            if (shortInfo != null) subtitleParts.add(shortInfo)
                            val subtitleText = subtitleParts.joinToString(" · ")

                            Text(
                                text = subtitleText,
                                style = MaterialTheme.typography.bodySmall,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }
            }
        }
    }
}
