/// Calendar Module
/// 
/// Este módulo proporciona funcionalidades completas de calendario
/// incluyendo eventos, asociaciones de notas con fechas, y gestión
/// de tareas temporales.

// Domain exports
export 'domain/entities/calendar_event.dart';
export 'domain/entities/date_note_association.dart';
export 'domain/repositories/calendar_repository.dart';
export 'domain/usecases/get_events_for_date.dart';
export 'domain/usecases/create_calendar_event.dart';
export 'domain/usecases/get_notes_for_date.dart';

// Data exports
export 'data/models/calendar_event_model.dart';
export 'data/models/date_note_association_model.dart';
export 'data/datasources/calendar_local_datasource.dart';
export 'data/repositories/calendar_repository_impl.dart';

// Presentation exports (se agregarán cuando las implementemos)
// export 'presentation/bloc/calendar_bloc.dart';
// export 'presentation/pages/calendar_page.dart';
// export 'presentation/widgets/calendar_widget.dart';
