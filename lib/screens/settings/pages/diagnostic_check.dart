import 'dart:io';
import 'package:dio/dio.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/studiewijzers.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class DiagnosticCheckPage extends StatefulWidget {
  const DiagnosticCheckPage({super.key});

  @override
  State<DiagnosticCheckPage> createState() => _DiagnosticCheckPageState();
}

class _DiagnosticCheckPageState extends State<DiagnosticCheckPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _logLines = [];
  bool _isRunning = false;
  bool _hasRun = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _logLines.add(
        "Diagnostische check gereed.\nDruk op 'Starten' om de check te beginnen.");
  }

  void _log(String line) {
    if (mounted) {
      String scrubbed = line;
      // Scrub subdomains (e.g. schoolname.magister.net -> ***.magister.net)
      final regExp = RegExp(r'([\w\-]+)\.magister\.net');
      scrubbed = scrubbed.replaceAllMapped(regExp, (match) {
        return '***.magister.net';
      });

      // Scrub email addresses
      final emailRegExp = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
      scrubbed = scrubbed.replaceAll(emailRegExp, '***@***.***');

      setState(() {
        _logLines.add(scrubbed);
      });
      // Auto scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  String _formatException(Object e, [StackTrace? stackTrace]) {
    String details = "";
    if (e is DioException) {
      final status = e.response?.statusCode;
      final method = e.requestOptions.method;
      final path = e.requestOptions.path;
      final responseData = e.response?.data;
      final msg = e.message;
      details =
          "DioException [Status $status] op $method $path\n  Foutmelding: $msg\n  Response: $responseData";
    } else {
      details = e.toString();
    }
    if (stackTrace != null) {
      details += "\n  Stacktrace:\n$stackTrace";
    }
    return details;
  }

  Future<void> _runDiagnostics() async {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _progress = 0.0;
      _logLines.clear();
    });

    final profile = activeProfile;
    final api = profile.account.value?.api;

    _log("=== DISCIPULUS DIAGNOSTISCHE CHECK ===");
    _log("Tijd: ${DateTime.now().toLocal()}");
    _log("Profiel: [VERBORGEN]");
    _log(
        "Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}");
    _log("App Versie: 1.0.0 (Diagnostics)");

    if (profile.isOffline ||
        profile.account.value?.tokenSet == null ||
        api == null) {
      _log(
          "\n[WARNING] Dit profiel is momenteel offline of mist inloggegevens.");
      _log("[WARNING] Diagnostics kunnen niet worden uitgevoerd.");
      setState(() {
        _isRunning = false;
        _progress = 1.0;
      });
      return;
    }

    _log("Endpoint: ${api.apiEndpoint}");
    _log("======================================\n");

    // Suppress Snackbars
    api.showSnackbars = false;

    final totalSteps = 15;
    int completedSteps = 0;

    void updateProgress() {
      completedSteps++;
      if (mounted) {
        setState(() {
          _progress = completedSteps / totalSteps;
        });
      }
    }

    try {
      // 1. Core Account
      _log("[1/$totalSteps] [INFO] Accountgegevens opvragen...");
      try {
        final acc = await api.account;
        _log("[OK] Account UUID: [VERBORGEN]");
        _log("[OK] Persoon: [VERBORGEN] (ID: [VERBORGEN])");
      } catch (e, s) {
        _log(
            "[ERROR] Accountgegevens laden mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 2. Schoolyears & Mentors & Grades & Grade details
      _log("\n[2/$totalSteps] [INFO] Schooljaren ophalen...");
      try {
        final schoolyears = await api
            .person(profile.id)
            .schoolyear()
            .schoolyears(
                range: DateTimeRange(
                    start: DateTime.now().subtract(const Duration(days: 365)),
                    end: DateTime.now()));
        _log("[OK] ${schoolyears.length} schoolja(a)r(en) gevonden.");
        if (schoolyears.isNotEmpty) {
          final firstSy = schoolyears.first;
          // Set profile reference and save to Isar to make it managed
          firstSy.profile.value = profile;
          isar.writeTxnSync(() {
            isar.schoolyears.putSync(firstSy);
          });
          _log(
              "[INFO] Eerste schooljaar succesvol gemapt en geregistreerd in database.");

          // Mentoren ophalen
          try {
            _log("[INFO] Mentoren ophalen voor schooljaar...");
            final mentors = await firstSy.getMentor;
            _log("[OK] ${mentors.length} mentor(en) gevonden.");
          } catch (e, s) {
            _log(
                "[WARNING] Mentoren ophalen mislukt (mogelijk niet toegestaan):\n${_formatException(e, s)}");
          }

          // Cijfers ophalen
          try {
            _log("[INFO] Cijfers ophalen voor schooljaar...");
            await firstSy.fillGrades();
            _log("[OK] Cijfers met succes gevuld in database.");
            if (firstSy.grades.isNotEmpty) {
              final firstGrade = firstSy.grades.first;
              // Link grade back to schoolyear and save to Isar to make it managed
              firstGrade.schoolyear.value = firstSy;
              isar.writeTxnSync(() {
                isar.grades.putSync(firstGrade);
              });
              _log(
                  "[INFO] Eerste cijfer succesvol gemapt en geregistreerd in database.");
              // Extra cijfer info ophalen
              try {
                _log("[INFO] Extra cijfer details ophalen...");
                await firstGrade.fill();
                _log("[OK] Extra cijfer info geladen en gemapt.");
              } catch (e, s) {
                _log(
                    "[WARNING] Extra cijfer details laden mislukt:\n${_formatException(e, s)}");
              }
            } else {
              _log("[INFO] Geen cijfers gevonden in dit schooljaar.");
            }
          } catch (e, s) {
            _log(
                "[WARNING] Cijfers laden mislukt (mogelijk geen permissie):\n${_formatException(e, s)}");
          }
        }
      } catch (e, s) {
        _log("[ERROR] Schooljaren laden mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 3. Calendar Events
      _log(
          "\n[3/$totalSteps] [INFO] Agenda afspraken ophalen (vandaag tot morgen)...");
      try {
        final events = await api.person(profile.id).calendarEvents(
            DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(const Duration(days: 1))));
        _log("[OK] ${events.length} afspraken/absenties gevonden.");
        if (events.isNotEmpty) {
          final firstEvent = events.first;
          // Set profile reference and save to Isar
          firstEvent.profile.value = profile;
          isar.writeTxnSync(() {
            isar.calendarEvents.putSync(firstEvent);
          });
          _log("[INFO] Eerste afspraak succesvol gemapt en geregistreerd.");
          if (firstEvent.selfUrl != null) {
            try {
              _log("[INFO] Afspraak details laden...");
              await firstEvent.fill();
              _log("[OK] Afspraak details met succes geladen en gemapt.");
            } catch (e, s) {
              _log(
                  "[WARNING] Afspraak details laden mislukt:\n${_formatException(e, s)}");
            }
          } else {
            _log("[INFO] Afspraak heeft geen selfUrl voor detail check.");
          }
        }
      } catch (e, s) {
        _log(
            "[ERROR] Agenda afspraken ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 4. Assignments
      _log(
          "\n[4/$totalSteps] [INFO] Opdrachten ophalen (afgelopen 30 dagen)...");
      try {
        final assignments = await api.person(profile.id).assignments(
            DateTimeRange(
                start: DateTime.now().subtract(const Duration(days: 30)),
                end: DateTime.now().add(const Duration(days: 7))));
        _log("[OK] ${assignments.length} opdrachten gevonden.");
        if (assignments.isNotEmpty) {
          final firstAssignment = assignments.first;
          // Set profile reference and save to Isar
          firstAssignment.profile.value = profile;
          isar.writeTxnSync(() {
            isar.assignments.putSync(firstAssignment);
          });
          _log("[INFO] Eerste opdracht succesvol gemapt en geregistreerd.");
          try {
            _log("[INFO] Opdracht details laden...");
            await firstAssignment.fill();
            _log(
                "[OK] Opdracht details geladen. Aantal bijlagen: ${firstAssignment.bronnen.length}, versies: ${firstAssignment.versies.length}");
            if (firstAssignment.versies.isNotEmpty) {
              final firstVersion = firstAssignment.versies.first;
              // Link version back to assignment and save to Isar
              firstVersion.assignment.value = firstAssignment;
              isar.writeTxnSync(() {
                isar.assignmentVersions.putSync(firstVersion);
              });
              _log("[INFO] Eerste versie details laden...");
              await firstVersion.fill();
              _log("[OK] Eerste versie details geladen en gemapt.");
            }
          } catch (e, s) {
            _log(
                "[WARNING] Opdracht details laden mislukt:\n${_formatException(e, s)}");
          }
        }
      } catch (e, s) {
        _log("[ERROR] Opdrachten ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 5. Leermiddelen
      _log("\n[5/$totalSteps] [INFO] Lesmateriaal (leermiddelen) ophalen...");
      try {
        final leermiddelen = await api.person(profile.id).leermiddelen;
        _log("[OK] ${leermiddelen.length} lesmaterialen gevonden.");
        if (leermiddelen.isNotEmpty) {
          _log("[INFO] Eerste lesmateriaal succesvol gemapt.");
        }
      } catch (e, s) {
        _log(
            "[ERROR] Lesmateriaal ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 6. Studiewijzers & Projecten
      _log("\n[6/$totalSteps] [INFO] Studiewijzers en projecten ophalen...");
      try {
        final studiewijzers = await api.person(profile.id).studiewijzers(
              includeProjects: true,
              includeStudiewijzers: true,
            );
        _log("[OK] ${studiewijzers.length} studiewijzers/projecten gevonden.");
        if (studiewijzers.isNotEmpty) {
          final firstSw = studiewijzers.first;
          // Set profile reference and save to Isar
          firstSw.profile.value = profile;
          isar.writeTxnSync(() {
            isar.studiewijzers.putSync(firstSw);
          });
          _log("[INFO] Eerste studiewijzer succesvol gemapt en geregistreerd.");
          if (firstSw.selfUrl != null) {
            try {
              _log("[INFO] Studiewijzer details laden...");
              await firstSw.fill();
              _log(
                  "[OK] Studiewijzer details geladen. Aantal onderdelen: ${firstSw.onderdelen.length}");
              if (firstSw.onderdelen.isNotEmpty) {
                final firstOnderdeel = firstSw.onderdelen.first;
                // Link onderdeel back to studiewijzer and save to Isar
                firstOnderdeel.studiewijzer.value = firstSw;
                isar.writeTxnSync(() {
                  isar.studiewijzerOnderdeels.putSync(firstOnderdeel);
                });
                _log("[INFO] Eerste onderdeel details laden...");
                await firstOnderdeel.fill();
                _log("[OK] Eerste onderdeel details geladen en gemapt.");
              }
            } catch (e, s) {
              _log(
                  "[WARNING] Studiewijzer/project details laden mislukt:\n${_formatException(e, s)}");
            }
          } else {
            _log("[INFO] Studiewijzer heeft geen selfUrl.");
          }
        }
      } catch (e, s) {
        _log(
            "[ERROR] Studiewijzers en projecten ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 7. Profile Picture
      _log("\n[7/$totalSteps] [INFO] Pasfoto ophalen...");
      try {
        final pic = await api.person(profile.id).profilepicture;
        if (pic != null) {
          _log("[OK] Pasfoto geladen en gemapt (Grootte: ${pic.length} bytes)");
        } else {
          _log("[OK] Pasfoto is leeg (geen foto ingesteld).");
        }
      } catch (e, s) {
        _log("[ERROR] Pasfoto ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 8. Activities
      _log("\n[8/$totalSteps] [INFO] Activiteiten ophalen...");
      try {
        final act = await api.person(profile.id).activiteiten;
        _log("[OK] ${act.length} activiteiten gevonden.");
        if (act.isNotEmpty) {
          _log("[INFO] Eerste activiteit succesvol gemapt.");
        }
      } catch (e, s) {
        _log(
            "[ERROR] Activiteiten ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 9. Profile Info
      _log("\n[9/$totalSteps] [INFO] Profielgegevens ophalen...");
      try {
        final info = await api.person(profile.id).getProfileInfo;
        _log(
            "[OK] Profielgegevens geladen en gemapt: E-mail = [VERBORGEN], Telefoon = [VERBORGEN]");
      } catch (e, s) {
        _log(
            "[ERROR] Profielgegevens ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 10. Profile Address
      _log("\n[10/$totalSteps] [INFO] Adressen ophalen...");
      try {
        final addresses = await api.person(profile.id).getProfileAddress;
        _log("[OK] ${addresses.length} adressen gevonden.");
        if (addresses.isNotEmpty) {
          _log(
              "[INFO] Eerste adres succesvol gemapt (Straat/Huisnummer: [VERBORGEN])");
        }
      } catch (e, s) {
        _log("[ERROR] Adressen ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 11. Career Details
      _log("\n[11/$totalSteps] [INFO] Opleidingsgegevens ophalen...");
      try {
        final career = await api.person(profile.id).getCareer;
        _log(
            "[OK] Opleidingsgegevens geladen en gemapt: Studie = [VERBORGEN], Klas = [VERBORGEN]");
      } catch (e, s) {
        _log(
            "[ERROR] Opleidingsgegevens ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 12. Authorization
      _log("\n[12/$totalSteps] [INFO] Autorisatiegegevens ophalen...");
      try {
        await api.person(profile.id).getAuthorization;
        _log("[OK] Autorisatiegegevens geladen.");
      } catch (e, s) {
        _log(
            "[ERROR] Autorisatiegegevens ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 13. Toestemming Antwoorden
      _log("\n[13/$totalSteps] [INFO] Toestemming antwoorden ophalen...");
      try {
        final answers = await api.person(profile.id).getAnswers;
        _log("[OK] ${answers.length} toestemming antwoorden gevonden.");
      } catch (e, s) {
        _log(
            "[ERROR] Toestemming antwoorden ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 14. External Bron Sources
      _log("\n[14/$totalSteps] [INFO] Externe bronnen ophalen...");
      try {
        final bronnen = await api.person(profile.id).getBronSources;
        _log("[OK] ${bronnen.length} externe bronnen gevonden.");
      } catch (e, s) {
        _log(
            "[ERROR] Externe bronnen ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      // 15. Message Folders & Messages & Message Details
      _log("\n[15/$totalSteps] [INFO] Berichtmappen ophalen...");
      try {
        final folders = await api.messages.folders;
        _log("[OK] ${folders.length} mappen gevonden.");
        if (folders.isNotEmpty) {
          final firstFolder = folders.first;
          // Set profile reference and save to Isar
          firstFolder.profile.value = profile;
          isar.writeTxnSync(() {
            isar.messagesFolders.putSync(firstFolder);
          });
          _log("[INFO] Eerste map succesvol gemapt.");

          try {
            _log("[INFO] Eerste bericht in map ophalen...");
            final messages = await firstFolder.getMessages(amount: 1);
            _log(
                "[OK] Berichten ophalen gelukt. Aantal in lijst: ${messages.length}");
            if (messages.isNotEmpty) {
              final firstMsg = messages.first;
              // Link message back to folder and save to Isar
              firstMsg.map.value = firstFolder;
              isar.writeTxnSync(() {
                isar.berichts.putSync(firstMsg);
              });
              _log(
                  "[INFO] Eerste bericht succesvol gemapt (Onderwerp: [VERBORGEN], Afzender: [VERBORGEN])");
              try {
                _log("[INFO] Bericht inhoud en details laden...");
                await firstMsg.fill();
                _log(
                    "[OK] Bericht details geladen en gemapt. Inhoudslengte = ${firstMsg.inhoud?.length ?? 0}");
              } catch (e, s) {
                _log(
                    "[WARNING] Bericht details laden mislukt:\n${_formatException(e, s)}");
              }
            }
          } catch (e, s) {
            _log(
                "[WARNING] Berichten in map ophalen mislukt:\n${_formatException(e, s)}");
          }
        }
      } catch (e, s) {
        _log(
            "[ERROR] Berichtmappen ophalen mislukt:\n${_formatException(e, s)}");
      }
      updateProgress();

      _log("\n======================================");
      _log("=== DIAGNOSTISCHE CHECK VOLTOOID ===");
      _log("======================================");
    } catch (e, s) {
      _log(
          "\n[FATAL] Er is een onverwachte fout opgetreden tijdens de check:\n${_formatException(e, s)}");
    } finally {
      api.showSnackbars = true;
      if (mounted) {
        setState(() {
          _isRunning = false;
          _progress = 1.0;
        });
      }
    }
  }

  void _copyToClipboard() {
    final text = _logLines.join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logs gekopieerd naar klembord")),
    );
  }

  void _shareLogs() {
    final text = _logLines.join('\n');
    Share.share(
      text,
      subject: "Discipulus Diagnostische Check",
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Diagnostische check"),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isRunning)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Console Output",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: _logLines.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: _logLines.length,
                                  itemBuilder: (context, index) {
                                    final line = _logLines[index];
                                    Color textColor = Colors.white;
                                    if (line.contains("[OK]")) {
                                      textColor = Colors.greenAccent;
                                    } else if (line.contains("[WARNING]")) {
                                      textColor = Colors.amberAccent;
                                    } else if (line.contains("[ERROR]") ||
                                        line.contains("[FATAL]")) {
                                      textColor = Colors.redAccent;
                                    } else if (line.contains("[INFO]")) {
                                      textColor = Colors.lightBlueAccent;
                                    }
                                    return Text(
                                      line,
                                      style: const TextStyle(
                                        fontFamily: 'Courier',
                                        fontSize: 12,
                                        height: 1.3,
                                      ).copyWith(color: textColor),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: OutlinedButton.icon(
                        onPressed: _isRunning
                            ? null
                            : () {
                                setState(() {
                                  _hasRun = true;
                                });
                                _runDiagnostics();
                              },
                        icon: const Icon(Icons.refresh),
                        label: Text(_hasRun ? "Opnieuw" : "Starten"),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilledButton.icon(
                        onPressed:
                            !_hasRun || _logLines.isEmpty ? null : _shareLogs,
                        icon: const Icon(Icons.share),
                        label: const Text("Delen"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Tip: Gebruik de Kopieer- of Delen-knop om deze logs eenvoudig te kopiëren en als bijlage toe te voegen aan een Github Issue of e-mail.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
