package dev.harrydekat.discipulus.wear

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.wear.compose.material3.AppScaffold
import androidx.wear.compose.material3.MaterialTheme
import androidx.wear.compose.material3.TimeText
import androidx.wear.compose.navigation.SwipeDismissableNavHost
import androidx.wear.compose.navigation.composable
import androidx.wear.compose.navigation.rememberSwipeDismissableNavController
import dev.harrydekat.discipulus.wear.ui.ContentView
import dev.harrydekat.discipulus.wear.ui.EventDetailView
import dev.harrydekat.discipulus.wear.ui.GradeDetailView
import dev.harrydekat.discipulus.wear.ui.GradesListView
import dev.harrydekat.discipulus.wear.ui.ScheduleListView
import dev.harrydekat.discipulus.wear.ui.SettingsView
import dev.harrydekat.discipulus.wear.ui.SettingsScheduleView
import dev.harrydekat.discipulus.wear.ui.SettingsNotificationsView
import dev.harrydekat.discipulus.wear.ui.SettingsConnectionView
import dev.harrydekat.discipulus.wear.ui.SetupWatchView
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel

class WearAppActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                val navController = rememberSwipeDismissableNavController()
                val wearViewModel: WearViewModel = viewModel(
                    factory = androidx.lifecycle.ViewModelProvider.AndroidViewModelFactory.getInstance(application)
                )

                androidx.compose.runtime.LaunchedEffect(Unit) {
                    if (wearViewModel.startDestination.value == "schedule") {
                        navController.navigate("schedule")
                    }
                }

                AppScaffold() {
                    SwipeDismissableNavHost(
                        navController = navController,
                        startDestination = "home",
                        modifier = Modifier
                            .fillMaxSize()
                            .background(MaterialTheme.colorScheme.background)
                    ) {
                        composable("home") {
                            ContentView(
                                viewModel = wearViewModel,
                                onNavigateToSchedule = { navController.navigate("schedule") },
                                onNavigateToGrades = { navController.navigate("grades") },
                                onNavigateToSettings = { navController.navigate("settings") },
                                onNavigateToEventDetail = { navController.navigate("event_detail") }
                            )
                        }
                        composable("schedule") {
                            ScheduleListView(
                                viewModel = wearViewModel,
                                onNavigateToEventDetail = { navController.navigate("event_detail") }
                            )
                        }
                        composable("grades") {
                            GradesListView(
                                viewModel = wearViewModel,
                                onNavigateToGradeDetail = { navController.navigate("grade_detail") }
                            )
                        }
                        composable("settings") {
                            SettingsView(
                                viewModel = wearViewModel,
                                onNavigateToScheduleSettings = { navController.navigate("settings_schedule") },
                                onNavigateToNotificationsSettings = { navController.navigate("settings_notifications") },
                                onNavigateToConnectionSettings = { navController.navigate("settings_connection") }
                            )
                        }
                        composable("settings_schedule") {
                            SettingsScheduleView(viewModel = wearViewModel)
                        }
                        composable("settings_notifications") {
                            SettingsNotificationsView(viewModel = wearViewModel)
                        }
                        composable("settings_connection") {
                            SettingsConnectionView(
                                viewModel = wearViewModel,
                                onNavigateToSetup = { navController.navigate("setup") }
                            )
                        }
                        composable("setup") {
                            SetupWatchView(
                                viewModel = wearViewModel,
                                onDone = { navController.popBackStack() }
                            )
                        }
                        composable("grade_detail") {
                            val selectedGrade by wearViewModel.selectedGrade.collectAsState()
                            selectedGrade?.let { grade ->
                                GradeDetailView(grade = grade)
                            }
                        }
                        composable("event_detail") {
                            val selectedEvent by wearViewModel.selectedEvent.collectAsState()
                            selectedEvent?.let { event ->
                                EventDetailView(event = event, viewModel = wearViewModel)
                            }
                        }
                    }
                }
            }
        }
    }
}
