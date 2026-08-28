package dev.harrydekat.discipulus.wear.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.*
import androidx.wear.compose.foundation.pager.HorizontalPager
import androidx.wear.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material3.*
import dev.harrydekat.discipulus.wear.models.SchoolYearData
import dev.harrydekat.discipulus.wear.models.SubjectAverage
import dev.harrydekat.discipulus.wear.models.WatchGrade
import dev.harrydekat.discipulus.wear.viewmodel.WearViewModel
import java.text.SimpleDateFormat
import java.util.Locale

@Composable
fun GradesListView(viewModel: WearViewModel, onNavigateToGradeDetail: () -> Unit) {
    val schoolyears by viewModel.schoolyears.collectAsState()

    LaunchedEffect(Unit) {
        viewModel.requestGrades()
    }

    if (schoolyears.isEmpty()) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            Text(
                "Geen cijfers gevonden",
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                style = MaterialTheme.typography.bodySmall,
                textAlign = TextAlign.Center
            )
        }
    } else {
        val pagerState = rememberPagerState(pageCount = { schoolyears.size })
        val lastUpdate by viewModel.lastUpdate.collectAsState()

        Box(modifier = Modifier.fillMaxSize()) {
            HorizontalPager(
                state = pagerState,
                modifier = Modifier.fillMaxSize()
            ) { page ->
                SchoolYearGradesContent(
                    schoolYear = schoolyears[page],
                    lastUpdate = lastUpdate,
                    onGradeClick = { grade ->
                        viewModel.selectGrade(grade)
                        onNavigateToGradeDetail()
                    }
                )
            }

            // Official M3 page indicator — only show if multiple years
            if (schoolyears.size > 1) {
                HorizontalPageIndicator(
                    pagerState = pagerState,
                    modifier = Modifier
                        .align(Alignment.BottomCenter)
                        .padding(bottom = 4.dp)
                )
            }
        }
    }
}

@Composable
fun SchoolYearGradesContent(
    schoolYear: SchoolYearData,
    lastUpdate: java.util.Date?,
    onGradeClick: (WatchGrade) -> Unit
) {
    val listState = rememberScalingLazyListState()

    ScreenScaffold(scrollState = listState) {
        ScalingLazyColumn(
            modifier = Modifier.fillMaxSize(),
            state = listState,
            horizontalAlignment = Alignment.CenterHorizontally,
            contentPadding = PaddingValues(horizontal = 0.dp, vertical = 10.dp)
        ) {
            // School Year Header
            item {
                Text(
                    text = schoolYear.name,
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.padding(bottom = 2.dp)
                )
            }

            // ── Subject Averages ──
            item {
                Text(
                    text = "Gemiddelden",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 4.dp, start = 14.dp, end = 14.dp)
                )
            }

            item {
                if (schoolYear.averages.isEmpty()) {
                    Text(
                        "Geen gemiddelden",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(vertical = 4.dp)
                    )
                } else {
                    val sorted = schoolYear.averages.sortedByDescending { it.average }
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .horizontalScroll(rememberScrollState())
                            .padding(horizontal = 14.dp),
                        horizontalArrangement = Arrangement.spacedBy(5.dp)
                    ) {
                        sorted.forEach { avg ->
                            SubjectAverageBadge(avg)
                        }
                    }
                }
            }

            item { Spacer(modifier = Modifier.height(8.dp)) }

            // ── Recent Grades ──
            item {
                Text(
                    text = "Recente cijfers",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(bottom = 4.dp, start = 14.dp, end = 14.dp)
                )
            }

            if (schoolYear.recentGrades.isEmpty()) {
                item {
                    Text(
                        "Geen recente cijfers",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        modifier = Modifier.padding(vertical = 4.dp)
                    )
                }
            } else {
                items(schoolYear.recentGrades.size) { index ->
                    val grade = schoolYear.recentGrades[index]
                    GradeCard(
                        grade = grade,
                        onClick = { onGradeClick(grade) }
                    )
                }
            }

            item {
                LastUpdateFooter(lastUpdate = lastUpdate)
            }
        }
    }
}

// ── Subject Average Badge ──
@Composable
fun SubjectAverageBadge(avg: SubjectAverage) {
    val averageVal = avg.average ?: 0.0
    val isSufficient = averageVal >= 5.5 || averageVal == 0.0
    val valueColor = if (isSufficient)
        MaterialTheme.colorScheme.onSurface
    else
        MaterialTheme.colorScheme.error

    val bgColor = if (isSufficient)
        MaterialTheme.colorScheme.surfaceContainer
    else
        MaterialTheme.colorScheme.errorContainer.copy(alpha = 0.5f)

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
        modifier = Modifier
            .size(36.dp)
            .clip(CircleShape)
            .background(bgColor)
    ) {
        Text(
            text = avg.subject.take(3).uppercase(),
            style = MaterialTheme.typography.labelSmall.copy(
                fontSize = 7.sp,
                fontWeight = FontWeight.Bold,
                lineHeight = 8.sp
            ),
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            maxLines = 1
        )
        Text(
            text = if (averageVal > 0) String.format(Locale.US, "%.1f", averageVal) else "-",
            style = MaterialTheme.typography.labelSmall.copy(
                fontSize = 10.sp,
                fontWeight = FontWeight.Bold,
                lineHeight = 12.sp
            ),
            color = valueColor,
            maxLines = 1
        )
    }
}

// ── Grade Card ──
@Composable
fun GradeCard(grade: WatchGrade, onClick: () -> Unit) {
    val df = SimpleDateFormat("dd MMM", Locale("nl", "NL"))
    val isSufficient = grade.isVoldoende

    val cardBg = if (isSufficient)
        MaterialTheme.colorScheme.surfaceContainer
    else
        MaterialTheme.colorScheme.errorContainer.copy(alpha = 0.35f)

    val badgeBg = if (isSufficient)
        MaterialTheme.colorScheme.primaryContainer
    else
        MaterialTheme.colorScheme.errorContainer

    val badgeText = if (isSufficient)
        MaterialTheme.colorScheme.onPrimaryContainer
    else
        MaterialTheme.colorScheme.onErrorContainer

    Card(
        onClick = onClick,
        modifier = Modifier
            .fillMaxWidth()
            .height(48.dp) // Constrain card height to be as compact as possible
            .padding(horizontal = 10.dp, vertical = 1.dp), // Safe horizontal margins
        colors = CardDefaults.cardColors(
            containerColor = cardBg
        ),
        contentPadding = PaddingValues(horizontal = 8.dp, vertical = 2.dp) // Tight padding inside card
    ) {
        Row(
            modifier = Modifier.fillMaxSize(), // Fill available card height to center content vertically
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Grade badge — circular leader, matching shape of hour indicator
            Box(
                modifier = Modifier
                    .size(28.dp)
                    .clip(CircleShape)
                    .background(badgeBg),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = grade.grade,
                    style = MaterialTheme.typography.labelSmall.copy(
                        fontWeight = FontWeight.Bold,
                        fontSize = 11.sp
                    ),
                    color = badgeText
                )
            }

            Spacer(modifier = Modifier.width(6.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = grade.subject,
                    style = MaterialTheme.typography.labelMedium,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    color = MaterialTheme.colorScheme.onSurface
                )
                Row(verticalAlignment = Alignment.CenterVertically) {
                    if (grade.date != null) {
                        Text(
                            text = df.format(grade.date),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                    if (grade.weight != null && grade.weight > 0) {
                        if (grade.date != null) {
                            Text(
                                " · ",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                        Text(
                            text = "${grade.weight.toInt()}x",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                    if (grade.isPTA) {
                        Text(
                            " · PTA",
                            style = MaterialTheme.typography.bodySmall.copy(fontWeight = FontWeight.Bold),
                            color = Color(0xFFFFB74D)
                        )
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
                .padding(vertical = 12.dp, horizontal = 18.dp),
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
