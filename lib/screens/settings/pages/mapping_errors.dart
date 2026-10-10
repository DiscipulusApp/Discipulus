import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/utils/mapping_logger.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MappingErrorsListScreen extends StatefulWidget {
  const MappingErrorsListScreen({super.key});

  @override
  State<MappingErrorsListScreen> createState() => _MappingErrorsListScreenState();
}

class _MappingErrorsListScreenState extends State<MappingErrorsListScreen> {
  void _clearErrors() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Fouten wissen?"),
        content: const Text(
          "Weet je zeker dat je alle geregistreerde mapping-fouten wilt verwijderen?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuleren"),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                mappingErrors = [];
              });
              Navigator.pop(context);
            },
            child: const Text("Wissen"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<MappingError> errors = mappingErrors;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapping-fouten"),
        actions: [
          if (errors.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.copy_rounded),
              tooltip: "Kopieer alle mapping-fouten",
              onPressed: () => MappingLogger.instance.copyToClipboard(context),
            ),
            IconButton(
              icon: const Icon(Icons.share_rounded),
              tooltip: "Deel mapping-rapport",
              onPressed: () => MappingLogger.instance.shareLog(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: "Wis alle fouten",
              onPressed: _clearErrors,
            ),
          ],
        ],
      ),
      body: errors.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 64,
                      color: context.cs.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Geen mapping-fouten geregistreerd",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Alle API-antwoorden zijn succesvol verwerkt en gekoppeld aan modellen.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.cs.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                // Privacy reassurance banner
                CustomCard(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: context.cs.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Alleen JSON-sleutels en gegevenstypes (<int>, <String>, etc.) worden gelogd. Er worden geen persoonsgegevens opgeslagen.",
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: context.cs.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Error list
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: errors.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final error = errors[index];
                    final timeFormatted = DateFormat("dd-MM-yyyy HH:mm:ss")
                        .format(error.timestamp);

                    return ExpansionTile(
                      leading: Icon(
                        Icons.data_object_rounded,
                        color: context.cs.error,
                      ),
                      title: Text(
                        error.modelName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeFormatted,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            error.error,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.cs.error,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Error message box
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: context.cs.errorContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Foutmelding:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: context.cs.error,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SelectableText(
                                      error.error,
                                      style: TextStyle(
                                        fontFamily: "monospace",
                                        color: context.cs.onErrorContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Sanitized Schema box
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Type-Schema:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.copy_rounded,
                                    ),
                                    onPressed: () {
                                      MappingLogger.instance.copyToClipboard(
                                        context,
                                        specificError: error,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      context.cs.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SelectableText(
                                  error.formattedSchema,
                                  style: const TextStyle(
                                    fontFamily: "monospace",
                                  ),
                                ),
                              ),

                              // StackTrace
                              if (error.stackTrace != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  "Stacktrace:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  child: SelectableText(
                                    error.stackTrace.toString(),
                                    style: const TextStyle(
                                      fontFamily: "monospace",
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),
                              // Bottom actions
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.share_rounded,
                                        size: 16),
                                    label: const Text("Deel fout"),
                                    onPressed: () => MappingLogger.instance
                                        .shareLog(context,
                                            specificError: error),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton.icon(
                                    icon: const Icon(Icons.copy_rounded,
                                        size: 16),
                                    label: const Text("Kopieer fout"),
                                    onPressed: () => MappingLogger.instance
                                        .copyToClipboard(context,
                                            specificError: error),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
