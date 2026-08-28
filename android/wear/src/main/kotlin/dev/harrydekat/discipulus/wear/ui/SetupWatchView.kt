package dev.harrydekat.discipulus.wear.ui

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PhoneAndroid
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel

@Composable
fun SetupWatchView(
    viewModel: WearViewModel,
    onDone: () -> Unit
) {
    val listState = rememberScalingLazyListState()
    val isStandalone by viewModel.isStandaloneMode.collectAsState()
    val standaloneAccount by viewModel.standaloneAccount.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()

    LaunchedEffect(Unit) {
        viewModel.triggerPhoneSetup()
    }

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            item {
                Text(
                    "Horloge instellen",
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = 4.dp)
                )
            }

            item {
                Icon(
                    imageVector = Icons.Default.PhoneAndroid,
                    contentDescription = "Telefoon",
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.size(36.dp).padding(vertical = 4.dp)
                )
            }

            item {
                Text(
                    "Kijk op je telefoon...",
                    style = MaterialTheme.typography.bodyMedium,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 8.dp)
                )
            }

            item {
                Text(
                    if (isStandalone && standaloneAccount != null) {
                        "Gekoppeld als: ${standaloneAccount?.accountName}"
                    } else if (!isStandalone) {
                        "Kies op de telefoon voor verbinding via telefoon of standalone internet."
                    } else {
                        "Open Discipulus op je telefoon om de verbinding te configureren."
                    },
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                )
            }

            item {
                FilledTonalButton(
                    onClick = onDone,
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 4.dp)
                ) {
                    Text(
                        text = "Sluiten",
                        style = MaterialTheme.typography.labelMedium,
                        textAlign = TextAlign.Center,
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            }
        }
    }
}
