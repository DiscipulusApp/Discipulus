import 'package:discipulus/core/routes.dart';
import 'package:discipulus/mcp/mcp_service.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:mcp_dart/mcp_dart.dart';

/// A property for a Discipulus MCP tool parameter.
class DiscipulusToolProperty {
  final String name;
  final String desc;
  final Type type;
  final bool isRequired;
  final List<String>? _enumValues;
  final List<String> Function()? _enumValuesFn;
  final DiscipulusToolProperty? items;
  final List<DiscipulusToolProperty>? properties;

  const DiscipulusToolProperty({
    required this.name,
    required this.desc,
    this.type = String,
    this.isRequired = false,
    List<String>? enumValues,
    List<String> Function()? enumValuesFn,
    this.items,
    this.properties,
  })  : _enumValues = enumValues,
        _enumValuesFn = enumValuesFn;

  List<String>? get enumValues =>
      _enumValuesFn != null ? _enumValuesFn!() : _enumValues;

  Map<String, dynamic> toJson() {
    String typeString;
    if (type == int || type == double || type == num) {
      typeString = 'integer';
    } else if (type == bool) {
      typeString = 'boolean';
    } else if (type == Map || type == Object) {
      typeString = 'object';
    } else if (type == List) {
      typeString = 'array';
    } else {
      typeString = 'string';
    }

    final schema = <String, dynamic>{
      'type': typeString,
      'description': desc,
      if (enumValues != null && enumValues!.isNotEmpty) 'enum': enumValues,
    };

    if (type == List) {
      if (properties != null && properties!.isNotEmpty) {
        final propsMap = <String, dynamic>{};
        final reqProps = <String>[];
        for (final p in properties!) {
          propsMap[p.name] = p.toJson();
          if (p.isRequired) reqProps.add(p.name);
        }
        schema['items'] = {
          'type': 'object',
          'properties': propsMap,
          if (reqProps.isNotEmpty) 'required': reqProps,
        };
      } else if (items != null) {
        schema['items'] = items!.toJson();
      }
    }

    return schema;
  }
}

/// A strongly typed Discipulus MCP tool definition.
class DiscipulusTool {
  final String name;
  final Type type;
  final String desc;
  final String? readableName;
  final List<DiscipulusToolProperty> properties;
  final Future<String> Function(Map<String, dynamic> args) onExecute;

  const DiscipulusTool({
    required this.name,
    required this.desc,
    this.readableName,
    this.type = String,
    this.properties = const [],
    required this.onExecute,
  });

  Map<String, dynamic> toJson() {
    final propertiesMap = <String, dynamic>{};
    final requiredProps = <String>[];

    for (final prop in properties) {
      propertiesMap[prop.name] = prop.toJson();
      if (prop.isRequired) {
        requiredProps.add(prop.name);
      }
    }

    return {
      'name': name,
      'description': desc,
      'type': type.toString(),
      'inputSchema': {
        'type': 'object',
        'properties': propertiesMap,
        if (requiredProps.isNotEmpty) 'required': requiredProps,
      },
    };
  }

  JsonObject get inputSchema {
    final schema = toJson()['inputSchema'] as Map<String, dynamic>;
    return JsonObject.fromJson(schema);
  }

  /// Converts this tool definition into an OpenAI / OpenRouter function tool declaration.
  Map<String, dynamic> toOpenAiTool() => {
        'type': 'function',
        'function': {
          'name': name,
          'description': desc,
          'parameters': toJson()['inputSchema'],
        },
      };

  Future<String> execute(Map<String, dynamic> args) => onExecute(args);
}

/// Registry and Dispatcher for Discipulus MCP Tools.
class DiscipulusMcpTools {
  static final List<DiscipulusTool> all = [
    DiscipulusTool(
      name: 'discipulus_get_schedule',
      desc:
          'Retrieves schedule timetable events and lessons for a date range. '
          'Returns a line-separated summary for each event: ID, Title, Subject, Start, End, Location, Teacher, Status, Type, IsCompleted, and Notes preview (max 50 chars). '
          'Call discipulus_get_event_detail for full details, complete content, and attachments of a specific event.',
      readableName: 'Rooster ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'startDate',
          desc: 'Start date in ISO format (YYYY-MM-DD). Defaults to today.',
          type: String,
          isRequired: true,
        ),
        DiscipulusToolProperty(
          name: 'endDate',
          desc:
              'End date in ISO format (YYYY-MM-DD). If same as startDate, automatically adds one day.',
          type: String,
          isRequired: true,
        ),
        DiscipulusToolProperty(
          name: 'subject',
          desc:
              'Filter events by subject name or abbreviation (e.g. "wi", "wiskunde").',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'onlyTests',
          desc:
              'When true, returns only events that are tests, exams, or oral exams.',
          type: bool,
        ),
        DiscipulusToolProperty(
          name: 'onlyHomework',
          desc: 'When true, returns only events that have homework.',
          type: bool,
        ),
      ],
      onExecute: McpService.getSchedule,
    ),
    DiscipulusTool(
      name: 'discipulus_get_event_detail',
      desc:
          'Directly retrieves complete details for a single calendar event by its ID. '
          'Returns: ID, Title, Subject, Start, End, Location, Teacher, Type, Status, IsCompleted, Attachments (name, ID, size, local path), and full Content.',
      readableName: 'Afspraak details ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'id',
          desc: 'The unique integer ID of the calendar event.',
          type: int,
          isRequired: true,
        ),
      ],
      onExecute: McpService.getEventDetail,
    ),
    DiscipulusTool(
      name: 'discipulus_get_grades',
      desc:
          'Retrieves grades from Magister. Supports filtering by subject, date range, and limit.',
      readableName: 'Cijfers ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'limit',
          desc: 'Maximum number of recent grades to return. Default: 20.',
          type: int,
        ),
        DiscipulusToolProperty(
          name: 'startDate',
          desc: 'Filter grades entered after this date (ISO-8601 format, YYYY-MM-DD).',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'endDate',
          desc: 'Filter grades entered before this date (ISO-8601 format, YYYY-MM-DD).',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'subject',
          desc: 'Filter grades by subject name or abbreviation (e.g. "Wiskunde", "wi").',
          type: String,
        ),
      ],
      onExecute: McpService.getGrades,
    ),
    DiscipulusTool(
      name: 'discipulus_get_subject_averages',
      desc:
          'Retrieves calculated subject averages across all school years. The averages are computed directly from subject grade data and rounded to 2 decimal places (or whole integers if rounded is true), matching the app.',
      readableName: 'Gemiddelden ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'subject',
          desc: 'Filter averages by subject name or abbreviation.',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'rounded',
          desc:
              'When true, rounds the averages to whole integers, matching the rounded switch in the app. Default: false (2 decimal places).',
          type: bool,
        ),
      ],
      onExecute: McpService.getSubjectAverages,
    ),
    DiscipulusTool(
      name: 'discipulus_get_assignments',
      desc:
          'Retrieves homework assignments and coursework with deadlines, statuses, and concise previews. '
          'Call discipulus_get_assignment_detail to get full instructions and rubrics for a specific assignment.',
      readableName: 'Opdrachten ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'onlyOpen',
          desc: 'When true, returns only pending/open assignments. Default: false.',
          type: bool,
        ),
        DiscipulusToolProperty(
          name: 'subject',
          desc: 'Filter assignments by subject name (e.g. "Nederlands").',
          type: String,
        ),
      ],
      onExecute: McpService.getAssignments,
    ),
    DiscipulusTool(
      name: 'discipulus_get_assignment_detail',
      desc:
          'Directly retrieves complete instructions, full descriptions, submission versions, and feedback for a specific assignment by its ID.',
      readableName: 'Opdracht details ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'id',
          desc: 'The unique integer ID of the assignment.',
          type: int,
          isRequired: true,
        ),
      ],
      onExecute: McpService.getAssignmentDetail,
    ),
    DiscipulusTool(
      name: 'discipulus_get_messages',
      desc:
          'Retrieves recent inbox messages with subject, sender, date, and concise preview. '
          'Call discipulus_get_message_detail to read the full body of a message.',
      readableName: 'Berichten ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'limit',
          desc: 'Maximum number of messages to return. Default: 10.',
          type: int,
        ),
        DiscipulusToolProperty(
          name: 'unreadOnly',
          desc: 'When true, returns only unread messages. Default: false.',
          type: bool,
        ),
        DiscipulusToolProperty(
          name: 'query',
          desc: 'Search query to filter messages by subject or sender.',
          type: String,
        ),
      ],
      onExecute: McpService.getMessages,
    ),
    DiscipulusTool(
      name: 'discipulus_get_message_detail',
      desc:
          'Directly retrieves the complete message body (with HTML cleanly converted to plain text), all recipients, and attachment details for a specific message by its ID.',
      readableName: 'Bericht details ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'id',
          desc: 'The unique integer ID of the message.',
          type: int,
          isRequired: true,
        ),
      ],
      onExecute: McpService.getMessageDetail,
    ),
    DiscipulusTool(
      name: 'discipulus_get_profile',
      desc:
          'Retrieves the active student profile details (name, UUID, school, and current school year).',
      readableName: 'Profiel ophalen',
      type: String,
      properties: const [],
      onExecute: (args) => Future.value(McpService.getProfile(args)),
    ),
    DiscipulusTool(
      name: 'discipulus_switch_profile',
      desc:
          'Switches the active student profile in Discipulus by student UUID or name. '
          'If called with no arguments or not found, lists available profiles.',
      readableName: 'Profiel wisselen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'uuid',
          desc: 'The integer UUID of the profile to switch to.',
          type: int,
        ),
        DiscipulusToolProperty(
          name: 'name',
          desc: 'Full name or partial name of the student profile.',
          type: String,
        ),
      ],
      onExecute: McpService.switchProfile,
    ),
    DiscipulusTool(
      name: 'discipulus_edit_event',
      desc:
          'Edits one or multiple calendar events (notes/content, location, info type, status) or marks homework as completed/todo in Discipulus and syncs to Magister. Can accept an "events" list for editing multiple events in bulk, or individual event fields for editing a single event.',
      readableName: 'Rooster item(s) aanpassen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'events',
          desc:
              'List of event edit objects to update in bulk. Each object must include "id" and any fields to update (isCompleted, content, location, infoType, status).',
          type: List,
          properties: [
            DiscipulusToolProperty(
              name: 'id',
              desc: 'The unique integer ID of the calendar event to edit.',
              type: int,
              isRequired: true,
            ),
            DiscipulusToolProperty(
              name: 'isCompleted',
              desc:
                  'Whether homework for this lesson is marked completed (done) or uncompleted (todo).',
              type: bool,
            ),
            DiscipulusToolProperty(
              name: 'content',
              desc: 'New homework/notes content for this event.',
              type: String,
            ),
            DiscipulusToolProperty(
              name: 'location',
              desc: 'Updated room or location.',
              type: String,
            ),
            DiscipulusToolProperty(
              name: 'infoType',
              desc: 'Type of event.',
              type: String,
              enumValues: [
                'none',
                'homework',
                'test',
                'exam',
                'writtenExam',
                'oralExam',
                'information',
                'note',
              ],
            ),
            DiscipulusToolProperty(
              name: 'status',
              desc: 'Event status.',
              type: String,
              enumValues: [
                'unknown',
                'automaticallyScheduled',
                'manuallyScheduled',
                'changed',
                'manuallyCanceled',
                'automaticallyCanceled',
                'inUse',
                'finished',
                'used',
                'moved',
                'changedAndMoved',
              ],
            ),
          ],
        ),
        DiscipulusToolProperty(
          name: 'id',
          desc: 'The unique integer ID of a single calendar event to edit (if not using the "events" list).',
          type: int,
        ),
        DiscipulusToolProperty(
          name: 'isCompleted',
          desc: 'Whether homework for this lesson is marked completed (done) or uncompleted (todo).',
          type: bool,
        ),
        DiscipulusToolProperty(
          name: 'content',
          desc: 'New homework/notes content for this event.',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'location',
          desc: 'Updated room or location.',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'infoType',
          desc: 'Type of event.',
          type: String,
          enumValues: [
            'none',
            'homework',
            'test',
            'exam',
            'writtenExam',
            'oralExam',
            'information',
            'note',
          ],
        ),
        DiscipulusToolProperty(
          name: 'status',
          desc: 'Event status.',
          type: String,
          enumValues: [
            'unknown',
            'automaticallyScheduled',
            'manuallyScheduled',
            'changed',
            'manuallyCanceled',
            'automaticallyCanceled',
            'inUse',
            'finished',
            'used',
            'moved',
            'changedAndMoved',
          ],
        ),
      ],
      onExecute: McpService.editEvent,
    ),
    DiscipulusTool(
      name: 'discipulus_get_studiewijzers',
      desc:
          'Retrieves active studiewijzers (study guides / project curricula) with IDs, titles, period, loaded state, and section counts. If a studiewijzer has never been loaded before (Loaded: false / LastUsed: Never), its item count is unknown until you retrieve its details with discipulus_get_studiewijzer_detail.',
      readableName: 'Studiewijzers ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'query',
          desc: 'Filter study guides by title or subject keyword.',
          type: String,
        ),
      ],
      onExecute: McpService.getStudiewijzers,
    ),
    DiscipulusTool(
      name: 'discipulus_get_studiewijzer_detail',
      desc:
          'Directly retrieves complete sections, notes, and attachment resources for a single studiewijzer by its ID.',
      readableName: 'Studiewijzer details ophalen',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'id',
          desc: 'The unique integer ID of the studiewijzer.',
          type: int,
          isRequired: true,
        ),
      ],
      onExecute: McpService.getStudiewijzerDetail,
    ),
    DiscipulusTool(
      name: 'discipulus_get_statistics',
      desc:
          'Retrieves a concise summary of academic, timetable, and coursework statistics (overall weighted average, passing/failing grade counts and percentages, highest/lowest grades, subjects passing/failing, lesson attendance/cancellations, and coursework status).',
      readableName: 'Statistieken ophalen',
      type: String,
      properties: const [],
      onExecute: McpService.getStatistics,
    ),
    DiscipulusTool(
      name: 'discipulus_navigate_to_screen',
      desc: 'Navigates to a specific screen within the Discipulus app.',
      readableName: 'Navigeren naar scherm',
      type: String,
      properties: [
        DiscipulusToolProperty(
          name: 'screen',
          desc:
              'The name of the screen to navigate to (e.g. "Kalender", "Opdrachten", "Studiewijzers", "Berichten", "Recente cijfers").',
          type: String,
          isRequired: true,
          enumValuesFn: () => destinationLabels(
            activeProfileNullable?.account.value?.permissions,
          ),
        ),
      ],
      onExecute: McpService.navigateToScreen,
    ),
    DiscipulusTool(
      name: 'discipulus_compose_message',
      desc:
          'Opens the compose message sheet with prefilled recipient, subject, and body.',
      readableName: 'E-mail schrijven',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'recipient',
          desc: 'Name or email address of the recipient.',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'subject',
          desc: 'Subject of the message.',
          type: String,
        ),
        DiscipulusToolProperty(
          name: 'body',
          desc: 'Body content of the message. IN HTML',
          type: String,
        ),
      ],
      onExecute: McpService.composeMessage,
    ),
    DiscipulusTool(
      name: 'discipulus_download_file',
      desc:
          'Downloads a file or attachment (Bron) from Magister using Discipulus download manager and saves it to the system temporary directory (/tmp). Returns the local filesystem path on the host computer.',
      readableName: 'Bestand downloaden',
      type: String,
      properties: const [
        DiscipulusToolProperty(
          name: 'id',
          desc:
              'The unique integer ID of the file or attachment to download (from a studiewijzer, message, assignment, or calendar event).',
          type: int,
        ),
        DiscipulusToolProperty(
          name: 'name',
          desc:
              'The filename or search keyword of the attachment to download if the ID is unknown.',
          type: String,
        ),
      ],
      onExecute: McpService.downloadFile,
    ),
  ];

  /// Returns all tools as OpenAI / OpenRouter function definitions.
  static List<Map<String, dynamic>> get openAiTools =>
      all.map((t) => t.toOpenAiTool()).toList();

  static DiscipulusTool? getTool(String name) {
    for (final tool in all) {
      if (tool.name == name) return tool;
    }
    return null;
  }

  static Future<String> execute(String name, Map<String, dynamic> args) async {
    final tool = getTool(name);
    if (tool == null) {
      return "Functie '$name' niet herkend.";
    }
    try {
      return await tool.execute(args);
    } catch (e) {
      return "Fout bij uitvoeren van '$name': $e";
    }
  }

  static void registerAll(
    McpServer server,
    Future<CallToolResult> Function(String name, Map<String, dynamic> args)
        dispatcher,
  ) {
    for (final tool in all) {
      server.registerTool(
        tool.name,
        description: tool.desc,
        inputSchema: tool.inputSchema,
        callback: (args, extra) => dispatcher(tool.name, args),
      );
    }
  }
}
