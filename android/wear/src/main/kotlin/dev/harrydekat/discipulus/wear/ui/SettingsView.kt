package dev.harrydekat.discipulus.wear.ui

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.PhoneAndroid
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.ContextCompat
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*
import dev.harrydekat.discipulus.wear.models.ScheduleEvent
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel
import java.util.Calendar

/**
 * Main Settings Hub displaying categories for sub-pages with surface-colored buttons.
 */
@Composable
fun SettingsView(
    viewModel: WearViewModel,
    onNavigateToScheduleSettings: () -> Unit,
    onNavigateToNotificationsSettings: () -> Unit,
    onNavigateToConnectionSettings: () -> Unit
) {
    val listState = rememberScalingLazyListState()
    val isStandalone by viewModel.isStandaloneMode.collectAsState()
    val standaloneAccount by viewModel.standaloneAccount.collectAsState()

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState
        ) {
            item {
                Text(
                    text = "Instellingen",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = 4.dp)
                )
            }

            // 1. Weergave & Rooster
            item {
                FilledTonalButton(
                    onClick = onNavigateToScheduleSettings,
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    )
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Icon(
                            imageVector = Icons.Default.DateRange,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = "Rooster & Weergave",
                                style = MaterialTheme.typography.labelMedium,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                            Text(
                                text = "Tijden, indeling & pauzes",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                        }
                    }
                }
            }

            // 2. Meldingen & Trillingen
            item {
                FilledTonalButton(
                    onClick = onNavigateToNotificationsSettings,
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    )
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Icon(
                            imageVector = Icons.Default.Notifications,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = "Herinneringen",
                                style = MaterialTheme.typography.labelMedium,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                            Text(
                                text = "Trillingen vóór elke les",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                        }
                    }
                }
            }

            // 3. Verbinding & Account
            item {
                FilledTonalButton(
                    onClick = onNavigateToConnectionSettings,
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    )
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Icon(
                            imageVector = Icons.Default.PhoneAndroid,
                            contentDescription = null,
                            tint = MaterialTheme.colorScheme.primary,
                            modifier = Modifier.size(18.dp)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = "Verbinding",
                                style = MaterialTheme.typography.labelMedium,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                            val status = if (isStandalone && standaloneAccount != null) {
                                "Standalone (${standaloneAccount?.accountName})"
                            } else {
                                "Via telefoon"
                            }
                            Text(
                                text = status,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis
                            )
                        }
                    }
                }
            }
        }
    }
}

/**
 * Schedule Display Customization Subpage with live interactive Preview tile and surface-colored buttons.
 */
@Composable
fun SettingsScheduleView(viewModel: WearViewModel) {
    val listState = rememberScalingLazyListState()
    val showBreaks by viewModel.showBreakSeparators.collectAsState()
    val showCancelledLessons by viewModel.showCancelledLessons.collectAsState()
    val eventTimeDisplay by viewModel.eventTimeDisplay.collectAsState()
    val scheduleViewMode by viewModel.scheduleViewMode.collectAsState()
    val startDestination by viewModel.startDestination.collectAsState()

    // Example sample event to preview styling in real-time
    val sampleEvent = remember {
        val cal = Calendar.getInstance()
        cal.set(Calendar.HOUR_OF_DAY, 8)
        cal.set(Calendar.MINUTE, 30)
        val start = cal.time
        cal.set(Calendar.HOUR_OF_DAY, 9)
        cal.set(Calendar.MINUTE, 15)
        val end = cal.time
        ScheduleEvent(
            id = -999,
            name = "Wiskunde",
            shortName = "WIS",
            location = "103",
            infoType = 1,
            status = 0,
            startHourIndicator = 1,
            endHourIndicator = 1,
            startTime = start,
            endTime = end,
            isCompleted = false
        )
    }

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState
        ) {
            item {
                Text(
                    text = "Roosterweergave",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = 2.dp)
                )
            }

            // Live Example Preview Tile
            item {
                Text(
                    text = "Voorbeeld",
                    style = MaterialTheme.typography.labelSmall.copy(fontSize = 10.sp),
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(top = 2.dp, bottom = 2.dp)
                )
            }

            item {
                EventCard(
                    event = sampleEvent,
                    eventTimeDisplay = eventTimeDisplay,
                    onClick = {}
                )
            }

            if (showBreaks) {
                item {
                    BreakRow(durationMinutes = 15)
                }
            }

            item {
                Spacer(modifier = Modifier.height(4.dp))
            }

            // Option: Start Destination (Dashboard vs Rooster)
            item {
                val startPageLabel = if (startDestination == "schedule") "Rooster" else "Dashboard"
                FilledTonalButton(
                    onClick = {
                        val nextDest = if (startDestination == "schedule") "home" else "schedule"
                        viewModel.setStartDestination(nextDest)
                    },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    )
                ) {
                    Column(modifier = Modifier.fillMaxWidth().padding(vertical = 2.dp)) {
                        Text(
                            text = "Opstartscherm",
                            style = MaterialTheme.typography.labelMedium,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                        Text(
                            text = startPageLabel,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            // Option: Schedule View Mode (Vertical list vs Day-by-Day pager)
            item {
                val viewModeLabel = when (scheduleViewMode) {
                    1 -> "Dag per pagina (swipen)"
                    else -> "Verticale lijst (alles)"
                }
                FilledTonalButton(
                    onClick = {
                        val nextMode = (scheduleViewMode + 1) % 2
                        viewModel.setScheduleViewMode(nextMode)
                    },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    )
                ) {
                    Column(modifier = Modifier.fillMaxWidth().padding(vertical = 2.dp)) {
                        Text(
                            text = "Indeling",
                            style = MaterialTheme.typography.labelMedium,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                        Text(
                            text = viewModeLabel,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            // Option: Event Time Display
            item {
                val timeLabel = when (eventTimeDisplay) {
                    1 -> "Alleen starttijd (08:30)"
                    2 -> "Start- en eindtijd"
                    else -> "Verborgen"
                }
                FilledTonalButton(
                    onClick = {
                        val nextMode = (eventTimeDisplay + 1) % 3
                        viewModel.setEventTimeDisplay(nextMode)
                    },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    )
                ) {
                    Column(modifier = Modifier.fillMaxWidth().padding(vertical = 2.dp)) {
                        Text(
                            text = "Lestijden tonen",
                            style = MaterialTheme.typography.labelMedium,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                        Text(
                            text = timeLabel,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            // Option: Pauzes tonen Switch
            item {
                SwitchButton(
                    checked = showBreaks,
                    onCheckedChange = { viewModel.setShowBreakSeparators(it) },
                    label = { Text("Pauzes tonen", style = MaterialTheme.typography.labelMedium) },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp)
                )
            }

            // Option: Uitgevallen lessen tonen Switch
            item {
                SwitchButton(
                    checked = showCancelledLessons,
                    onCheckedChange = { viewModel.setShowCancelledLessons(it) },
                    label = { Text("Uitgevallen lessen tonen", style = MaterialTheme.typography.labelMedium) },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp)
                )
            }
        }
    }
}

/**
 * Notifications and Haptic Reminders Subpage with surface-colored buttons.
 */
@Composable
fun SettingsNotificationsView(viewModel: WearViewModel) {
    val listState = rememberScalingLazyListState()
    val hapticsEnabled by viewModel.hapticsEnabled.collectAsState()
    val hapticOffset by viewModel.hapticOffset.collectAsState()

    val context = LocalContext.current
    val permissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission(),
        onResult = { isGranted ->
            viewModel.setHapticsEnabled(isGranted)
        }
    )

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState
        ) {
            item {
                Text(
                    text = "Herinneringen",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = 4.dp)
                )
            }

            item {
                SwitchButton(
                    checked = hapticsEnabled,
                    onCheckedChange = { checked ->
                        if (checked && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            if (ContextCompat.checkSelfPermission(
                                    context,
                                    Manifest.permission.POST_NOTIFICATIONS
                                ) == PackageManager.PERMISSION_GRANTED
                            ) {
                                viewModel.setHapticsEnabled(true)
                            } else {
                                permissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
                            }
                        } else {
                            viewModel.setHapticsEnabled(checked)
                        }
                    },
                    label = { Text("Lesherinnering", style = MaterialTheme.typography.labelMedium) },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp)
                )
            }

            if (hapticsEnabled) {
                item {
                    val label = when (hapticOffset) {
                        1 -> "1 minuut vooraf"
                        else -> "$hapticOffset minuten vooraf"
                    }
                    FilledTonalButton(
                        onClick = {
                            val offsets = listOf(1, 2, 5, 10, 15)
                            val nextOffset = offsets[(offsets.indexOf(hapticOffset) + 1) % offsets.size]
                            viewModel.setHapticOffset(nextOffset)
                        },
                        modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                        colors = ButtonDefaults.filledTonalButtonColors(
                            containerColor = MaterialTheme.colorScheme.surfaceContainer,
                            contentColor = MaterialTheme.colorScheme.onSurface
                        )
                    ) {
                        Text(
                            text = "Tijd vooraf: $label",
                            style = MaterialTheme.typography.labelMedium,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            item {
                Text(
                    text = "Discipulus trilt op je pols vóór het begin van elke les.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp)
                )
            }
        }
    }
}

/**
 * Connection Mode & Sync Subpage with surface-colored buttons.
 */
@Composable
fun SettingsConnectionView(
    viewModel: WearViewModel,
    onNavigateToSetup: () -> Unit
) {
    val listState = rememberScalingLazyListState()
    val isStandalone by viewModel.isStandaloneMode.collectAsState()
    val standaloneAccount by viewModel.standaloneAccount.collectAsState()

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState
        ) {
            item {
                Text(
                    text = "Verbindingsmodus",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = 4.dp)
                )
            }

            item {
                val modeTitle = if (isStandalone && standaloneAccount != null) {
                    "Standalone (${standaloneAccount?.accountName})"
                } else {
                    "Alleen via telefoon"
                }
                val modeDesc = if (isStandalone && standaloneAccount != null) {
                    "Werkt zelfstandig via Wi-Fi/LTE"
                } else {
                    "Synchroniseert via Bluetooth"
                }

                FilledTonalButton(
                    onClick = onNavigateToSetup,
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                    colors = ButtonDefaults.filledTonalButtonColors(
                        containerColor = MaterialTheme.colorScheme.surfaceContainer,
                        contentColor = MaterialTheme.colorScheme.onSurface
                    )
                ) {
                    Column(modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp)) {
                        Text(
                            text = modeTitle,
                            style = MaterialTheme.typography.labelMedium,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                        Text(
                            text = modeDesc,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            if (isStandalone && standaloneAccount != null) {
                item {
                    FilledTonalButton(
                        onClick = { viewModel.refreshAll() },
                        modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                        colors = ButtonDefaults.filledTonalButtonColors(
                            containerColor = MaterialTheme.colorScheme.surfaceContainerHigh,
                            contentColor = MaterialTheme.colorScheme.onSurface
                        )
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.Center,
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Icon(
                                imageVector = Icons.Default.Refresh,
                                contentDescription = null,
                                modifier = Modifier.size(16.dp),
                                tint = MaterialTheme.colorScheme.primary
                            )
                            Spacer(modifier = Modifier.width(6.dp))
                            Text(
                                text = "Nu synchroniseren",
                                style = MaterialTheme.typography.labelMedium
                            )
                        }
                    }
                }

                item {
                    FilledTonalButton(
                        onClick = { viewModel.switchToCompanionMode() },
                        modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp),
                        colors = ButtonDefaults.filledTonalButtonColors(
                            containerColor = MaterialTheme.colorScheme.surfaceContainer,
                            contentColor = MaterialTheme.colorScheme.onSurface
                        )
                    ) {
                        Text(
                            text = "Terug naar Companion",
                            style = MaterialTheme.typography.labelMedium,
                            textAlign = TextAlign.Center,
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }
            }

            item {
                Text(
                    text = "Koppel via de Discipulus app op je telefoon om tussen Companion en Standalone te schakelen.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 6.dp)
                )
            }
        }
    }
}
