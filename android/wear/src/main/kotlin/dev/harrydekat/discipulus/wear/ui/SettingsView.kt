package dev.harrydekat.discipulus.wear.ui

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel

@Composable
fun SettingsView(viewModel: WearViewModel) {
    val listState = rememberScalingLazyListState()

    val showBreaks by viewModel.showBreakSeparators.collectAsState()
    val showCancelledLessons by viewModel.showCancelledLessons.collectAsState()
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
                    "Instellingen",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = 4.dp)
                )
            }

            item {
                SwitchButton(
                    checked = showCancelledLessons,
                    onCheckedChange = { viewModel.setShowCancelledLessons(it) },
                    label = { Text("Uitgevallen lessen tonen", style = MaterialTheme.typography.labelMedium) },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp)
                )
            }

            item {
                SwitchButton(
                    checked = showBreaks,
                    onCheckedChange = { viewModel.setShowBreakSeparators(it) },
                    label = { Text("Pauzes tonen", style = MaterialTheme.typography.labelMedium) },
                    modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp)
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
                    label = { Text("Herinneringen", style = MaterialTheme.typography.labelMedium) },
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
                        modifier = Modifier.fillMaxWidth().padding(bottom = 4.dp)
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
                    "Discipulus tikt je op je pols vóór elke les.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 8.dp)
                )
            }
        }
    }
}
