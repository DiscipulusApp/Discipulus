package dev.harrydekat.discipulus.wear.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.text.HtmlCompat
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel
import java.text.SimpleDateFormat
import java.util.Locale

@Composable
fun EventDetailView(
    event: ScheduleEvent,
    viewModel: WearViewModel
) {
    val currentSelectedEvent by viewModel.selectedEvent.collectAsState()
    val activeEvent = currentSelectedEvent ?: event

    val listState = rememberScalingLazyListState()
    val timeFormat = remember { SimpleDateFormat("HH:mm", Locale.getDefault()) }
    val dateFormat = remember { SimpleDateFormat("EEEE d MMMM", Locale("nl", "NL")) }

    val isCanceled = activeEvent.isCanceled
    val isCompleted = activeEvent.isCompleted && !isCanceled
    val isHomework = (activeEvent.infoType == 1 || (activeEvent.description != null && activeEvent.description.isNotBlank()) || activeEvent.isCompleted) && !isCanceled

    val badgeBg = if (isCanceled) {
        MaterialTheme.colorScheme.error
    } else if (isCompleted) {
        MaterialTheme.colorScheme.secondary
    } else if (activeEvent.infoType in 2..5) {
        MaterialTheme.colorScheme.tertiary
    } else {
        MaterialTheme.colorScheme.primary
    }

    val badgeTextColor = if (isCanceled) {
        MaterialTheme.colorScheme.onError
    } else if (isCompleted) {
        MaterialTheme.colorScheme.onSecondary
    } else if (activeEvent.infoType in 2..5) {
        MaterialTheme.colorScheme.onTertiary
    } else {
        MaterialTheme.colorScheme.onPrimary
    }

    // Parse HTML description to clean readable plain text
    val parsedDescription = remember(activeEvent.description) {
        activeEvent.description?.let { raw ->
            val clean = HtmlCompat.fromHtml(raw, HtmlCompat.FROM_HTML_MODE_COMPACT).toString().trim()
            if (clean.isNotEmpty()) clean else null
        }
    }

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState,
            horizontalAlignment = Alignment.CenterHorizontally,
            contentPadding = PaddingValues(horizontal = 10.dp, vertical = 24.dp)
        ) {
            // 1. Hour Badge or Time Header
            if (activeEvent.startHourIndicator != null) {
                item {
                    val hourText = if (activeEvent.endHourIndicator != null && activeEvent.startHourIndicator != activeEvent.endHourIndicator) {
                        "${activeEvent.startHourIndicator}/${activeEvent.endHourIndicator}"
                    } else {
                        "${activeEvent.startHourIndicator}e"
                    }
                    Box(
                        modifier = Modifier
                            .size(54.dp)
                            .clip(CircleShape)
                            .background(badgeBg),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = hourText,
                            style = MaterialTheme.typography.titleLarge.copy(
                                fontSize = 22.sp,
                                fontWeight = FontWeight.Bold
                            ),
                            color = badgeTextColor
                        )
                    }
                }
                item { Spacer(modifier = Modifier.height(6.dp)) }
            }

            // 2. Title & Subject Name
            item {
                Text(
                    text = activeEvent.name,
                    style = MaterialTheme.typography.titleMedium.copy(
                        fontWeight = FontWeight.Bold,
                        textDecoration = if (isCanceled) TextDecoration.LineThrough else TextDecoration.None
                    ),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 6.dp)
                )
            }

            // 3. Date & Time
            item {
                val startStr = timeFormat.format(activeEvent.startTime)
                val endStr = timeFormat.format(activeEvent.endTime)
                val durationMinutes = ((activeEvent.endTime.time - activeEvent.startTime.time) / (60 * 1000)).toInt()
                val durationText = if (durationMinutes > 0) " ($durationMinutes min)" else ""

                Text(
                    text = "${dateFormat.format(activeEvent.startTime).replaceFirstChar { it.uppercase() }}\n$startStr - $endStr$durationText",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                )
            }

            item { Spacer(modifier = Modifier.height(6.dp)) }

            // 4. Details Card (Location, Teacher, Info Type, Cancelled Status)
            item {
                Card(
                    onClick = {},
                    enabled = false,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 4.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    ),
                    contentPadding = PaddingValues(horizontal = 10.dp, vertical = 8.dp)
                ) {
                    Column(
                        modifier = Modifier.fillMaxWidth(),
                        verticalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        // Cancelled status
                        if (isCanceled) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Close,
                                    contentDescription = null,
                                    tint = MaterialTheme.colorScheme.error,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text(
                                    text = "Les is uitgevallen",
                                    style = MaterialTheme.typography.bodySmall.copy(
                                        fontWeight = FontWeight.Bold,
                                        color = MaterialTheme.colorScheme.error
                                    )
                                )
                            }
                        }

                        // Location
                        if (!activeEvent.location.isNullOrEmpty()) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Icon(
                                    imageVector = Icons.Default.LocationOn,
                                    contentDescription = null,
                                    tint = MaterialTheme.colorScheme.primary,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text(
                                    text = "Lokaal ${activeEvent.location}",
                                    style = MaterialTheme.typography.bodySmall
                                )
                            }
                        }

                        // Teacher
                        if (!activeEvent.teacher.isNullOrEmpty()) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Person,
                                    contentDescription = null,
                                    tint = MaterialTheme.colorScheme.primary,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text(
                                    text = activeEvent.teacher,
                                    style = MaterialTheme.typography.bodySmall
                                )
                            }
                        }

                        // Info Type Tag
                        val infoTypeName = when (activeEvent.infoType) {
                            1 -> "Huiswerk"
                            2 -> "Proefwerk"
                            3 -> "Toets"
                            4 -> "Schriftelijk"
                            5 -> "Mondeling"
                            6 -> "Informatie"
                            7 -> "Aantekening"
                            else -> null
                        }
                        if (infoTypeName != null) {
                            Row(
                                verticalAlignment = Alignment.CenterVertically,
                                modifier = Modifier.fillMaxWidth()
                            ) {
                                Icon(
                                    imageVector = Icons.Default.Schedule,
                                    contentDescription = null,
                                    tint = if (activeEvent.infoType in 2..5) MaterialTheme.colorScheme.tertiary else MaterialTheme.colorScheme.primary,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text(
                                    text = infoTypeName,
                                    style = MaterialTheme.typography.bodySmall.copy(fontWeight = FontWeight.SemiBold),
                                    color = if (activeEvent.infoType in 2..5) MaterialTheme.colorScheme.tertiary else MaterialTheme.colorScheme.onSurface
                                )
                            }
                        }
                    }
                }
            }

            // 5. Homework Completion Toggle Button
            if (isHomework) {
                item {
                    FilledTonalButton(
                        onClick = { viewModel.toggleEventCompletion(activeEvent.id) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(bottom = 4.dp),
                        colors = ButtonDefaults.filledTonalButtonColors(
                            containerColor = if (isCompleted) MaterialTheme.colorScheme.secondaryContainer else MaterialTheme.colorScheme.surfaceContainerHigh,
                            contentColor = if (isCompleted) MaterialTheme.colorScheme.onSecondaryContainer else MaterialTheme.colorScheme.onSurface
                        )
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            if (isCompleted) {
                                Icon(
                                    imageVector = Icons.Default.Check,
                                    contentDescription = null,
                                    tint = MaterialTheme.colorScheme.secondary,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                Text("Afgerond", style = MaterialTheme.typography.labelMedium)
                            } else {
                                Text("Markeer als afgerond", style = MaterialTheme.typography.labelMedium)
                            }
                        }
                    }
                }
            }

            // 6. Description / Inhoud (HTML converted)
            if (parsedDescription != null) {
                item {
                    Card(
                        onClick = {},
                        enabled = false,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(bottom = 4.dp),
                        colors = CardDefaults.cardColors(
                            containerColor = MaterialTheme.colorScheme.surfaceContainer,
                            contentColor = MaterialTheme.colorScheme.onSurface
                        ),
                        contentPadding = PaddingValues(horizontal = 10.dp, vertical = 8.dp)
                    ) {
                        Column(modifier = Modifier.fillMaxWidth()) {
                            Text(
                                text = if (isHomework) "Huiswerk" else "Omschrijving",
                                style = MaterialTheme.typography.labelSmall.copy(fontSize = 11.sp),
                                color = MaterialTheme.colorScheme.primary,
                                modifier = Modifier.padding(bottom = 4.dp)
                            )
                            Text(
                                text = parsedDescription,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurface
                            )
                        }
                    }
                }
            }
        }
    }
}
