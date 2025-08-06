import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../notifications/notification_service.dart';
import '../../features/notes/domain/entities/note.dart';
import '../../features/calendar/data/models/calendar_event_model.dart';
import '../../features/calendar/data/models/date_note_association_model.dart';
import '../../features/calendar/data/datasources/calendar_local_datasource.dart';
import '../../features/calendar/data/repositories/calendar_repository_impl.dart';
import '../../features/calendar/domain/repositories/calendar_repository.dart';
import '../../features/calendar/domain/usecases/get_events_for_date.dart';
import '../../features/calendar/domain/usecases/create_calendar_event.dart';
import '../../features/calendar/domain/usecases/get_notes_for_date.dart';
import '../../features/calendar/presentation/bloc/calendar_bloc.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // Register Hive adapters
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(CalendarEventModelAdapter());
  Hive.registerAdapter(DateNoteAssociationModelAdapter());
  
  // Open Hive boxes
  await Hive.openBox<Note>('notes');
  await Hive.openBox('settings');
  
  // Initialize Calendar datasource
  final calendarDatasource = CalendarLocalDatasource();
  await calendarDatasource.init();
  
  // Register Calendar services
  getIt.registerSingleton<CalendarLocalDatasource>(calendarDatasource);
  getIt.registerSingleton<CalendarRepository>(
    CalendarRepositoryImpl(localDatasource: getIt<CalendarLocalDatasource>()),
  );
  
  // Register Calendar use cases
  getIt.registerSingleton<GetEventsForDate>(
    GetEventsForDate(getIt<CalendarRepository>()),
  );
  getIt.registerSingleton<CreateCalendarEvent>(
    CreateCalendarEvent(getIt<CalendarRepository>()),
  );
  getIt.registerSingleton<GetNotesForDate>(
    GetNotesForDate(getIt<CalendarRepository>()),
  );
  
  // Register Calendar BLoC
  getIt.registerFactory<CalendarBloc>(
    () => CalendarBloc(
      getEventsForDate: getIt<GetEventsForDate>(),
      createCalendarEvent: getIt<CreateCalendarEvent>(),
      getNotesForDate: getIt<GetNotesForDate>(),
    ),
  );
  
  // Register services
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  
  // Configure additional dependencies here
}
