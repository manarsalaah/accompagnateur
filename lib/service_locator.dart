import 'package:accompagnateur/core/data/datasources/local/local_core_data_source.dart';
import 'package:accompagnateur/core/data/datasources/remote/remote_core_data_source.dart';
import 'package:accompagnateur/core/data/repositories/core_repo_impl.dart';
import 'package:accompagnateur/core/directory_manager/bloc/directory_manager_bloc.dart';
import 'package:accompagnateur/core/directory_manager/directory_manager_service.dart';
import 'package:accompagnateur/core/domain/repositories/core_repository.dart';
import 'package:accompagnateur/core/domain/usecases/add_or_update_comment.dart';
import 'package:accompagnateur/core/domain/usecases/add_or_udpate_day_description.dart';
import 'package:accompagnateur/core/domain/usecases/delete_attachment.dart';
import 'package:accompagnateur/core/domain/usecases/get_day_description.dart';
import 'package:accompagnateur/core/domain/usecases/get_sejour_attachements.dart';
import 'package:accompagnateur/core/domain/usecases/get_sejour_days.dart';
import 'package:accompagnateur/core/domain/usecases/send_sms.dart';
import 'package:accompagnateur/core/domain/usecases/upload_attachment_from_camera.dart';
import 'package:accompagnateur/core/permissions/bloc/permission_bloc.dart';
import 'package:accompagnateur/core/permissions/permission_service.dart';
import 'package:accompagnateur/features/audio_messages/data/data_source/local/audio_message_local_data_source.dart';
import 'package:accompagnateur/features/audio_messages/data/data_source/remote/audio_message_remote_datasource.dart';
import 'package:accompagnateur/features/audio_messages/data/repository/audio_message_repo_impl.dart';
import 'package:accompagnateur/features/audio_messages/domain/repository/audio_message_repository.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/cancel_recording.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/delete_audio_message.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/get_all_audio_messages.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/pause.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/pause_player.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/record.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/rename_audio_message.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/resume_recording.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/start_player.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/stop_recording.dart';
import 'package:accompagnateur/features/audio_messages/domain/usecase/upload_audio.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_message_getter/audio_message_getter_bloc.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_message_manager/audio_manager_cubit.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_player/audio_player_bloc.dart';
import 'package:accompagnateur/features/audio_messages/presentation/bloc/audio_recording/audio_recording_bloc.dart';
import 'package:accompagnateur/features/login/data/datasource/login_datasource.dart';
import 'package:accompagnateur/features/login/data/repository/login_repo_impl.dart';
import 'package:accompagnateur/features/login/domain/repository/login_repository.dart';
import 'package:accompagnateur/features/login/domain/usecase/login.dart';
import 'package:accompagnateur/features/photos/data/data_source/local/media_local_data_source.dart';
import 'package:accompagnateur/features/photos/data/repository/repository_impl.dart';
import 'package:accompagnateur/features/photos/domain/repository/photo_repository.dart';
import 'package:accompagnateur/features/photos/domain/usecase/capture_photo.dart';
import 'package:accompagnateur/features/photos/domain/usecase/get_medias.dart';
import 'package:accompagnateur/features/photos/domain/usecase/pick_media_from_gallery.dart';
import 'package:accompagnateur/features/photos/domain/usecase/save_media.dart';
import 'package:accompagnateur/features/photos/domain/usecase/upload_media_from_gallery.dart';
import 'package:accompagnateur/features/photos/presentation/bloc/get_medias/get_medias_bloc.dart';
import 'package:accompagnateur/features/photos/presentation/bloc/upload_media/upload_media_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'core/domain/usecases/delete_comment.dart';
import 'core/domain/usecases/delete_day_description.dart';
import 'core/domain/usecases/upload_visual_attachment.dart';
import 'features/audio_messages/domain/usecase/stop_player.dart';
import 'objectbox_singleton.dart';



final locator = GetIt.instance;
Future<void> setupLocator() async {
  //core registration
  await objectBoxSingleton.init();
  final ImagePicker picker = ImagePicker();
  locator.registerSingleton(picker);
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton(sharedPreferences);
  final dio = Dio();
  locator.registerSingleton(dio);
  //final objectBox = await ObjectBox.create();
  //locator.registerSingleton(objectBox);
  locator.registerSingleton(DirectoryManagerService());
  locator.registerSingleton<LoginDataSource>(LoginDataSource(dio: locator(), preferences: locator()));
  locator.registerSingleton<LocalCoreDataSource>(LocalCoreDataSourceImpl( directoryManagerService: locator()));
  locator.registerSingleton<RemoteCoreDataSource>(RemoteCoreDataSourceImpl(picker: locator(),dio: locator(), preferences: locator(),directoryManagerService: locator()));
  locator.registerSingleton<CoreRepository>(CoreRepositoryImpl(localDataSource: locator(), remoteDataSource: locator()));
  locator.registerSingleton<LoginRepository>(LoginRepositoryImpl(dataSource: locator()));
  locator.registerSingleton(Login(repository: locator()));
  locator.registerSingleton(SendSMS(repository: locator()));
locator.registerSingleton(GetSejourDays(repository: locator()));
locator.registerSingleton(GetSejourAttachements(repository: locator()));
locator.registerSingleton(UploadVisualAttachments(repository: locator()));
locator.registerSingleton(UploadAttachmentFromCamera(repository: locator()));
locator.registerSingleton(DeleteAttachment(repository: locator()));
locator.registerSingleton(AddOrUpdateComment(repository: locator()));
locator.registerSingleton(DeleteComment(repository: locator()));
locator.registerSingleton(GetDayDescription(repository: locator()));
locator.registerSingleton(DeleteDayDescription(repository: locator()));
locator.registerSingleton(AddOrUpdateDayDescription(repository: locator()));
  //Bloc
  locator.registerFactory(() => GetMediasBloc(useCase: locator()));
  locator.registerFactory(() => DirectoryManagerBloc(service: locator()));
  locator.registerFactory(() => PermissionBloc(service: locator()));
  locator.registerFactory(() => AudioRecordingBloc(
      record: locator(), stopRecording: locator(), pause: locator(), cancelRecording: locator(), resumeRecording: locator()));
  locator.registerFactory(() => AudioMessageGetterBloc(usecase: locator()));
  locator.registerFactory(() => AudioPlayerBloc(startPlayer: locator(), stopPlayer: locator(), pausePlayer: locator(), audioPlayer: locator()));
  locator.registerFactory(() => AudioManagerCubit(renameAudioMessage: locator(), deleteAudioMessage: locator(), uploadAudio: locator()));
  locator.registerFactory(() => UploadMediaBloc(fromGallery: locator(), saveMedia: locator(), pickMediaFromGallery: locator(),capturePhoto: locator()));

  //--------------------------------------
  //UseCase
  locator.registerLazySingleton(() => GetMedias(repository: locator()));
  locator.registerLazySingleton(() => CapturePhoto(repository: locator()));
  locator.registerLazySingleton(() => ResumeRecording(repository: locator()));
  locator.registerLazySingleton(() => CancelRecording(repository: locator()));
  locator.registerLazySingleton(() => StartRecording(repository: locator()));
  locator.registerLazySingleton(() => StopRecording(repository: locator()));
  locator.registerLazySingleton(() => Pause(repository: locator()));
  locator.registerLazySingleton(() => GetAllAudioMessages(repository: locator()));
  locator.registerLazySingleton(() => StartPlayer(repository: locator()));
  locator.registerLazySingleton(() => StopPlayer(repository: locator()));
  locator.registerLazySingleton(() => PausePlayer(repository: locator()));
  locator.registerLazySingleton(() => RenameAudioMessage(repository: locator()));
  locator.registerLazySingleton(() => DeleteAudioMessage(repository: locator()));
  locator.registerLazySingleton(() => UploadMediaFromGallery(repository: locator()));
  locator.registerLazySingleton(() => PickMediaFromGallery(repository: locator()));
  locator.registerLazySingleton(() => SaveMedia(repository: locator()));
  locator.registerLazySingleton(() => UploadAudio(repository: locator()));


  //--------------------------------------
  //Repository
  locator.registerLazySingleton<AudioMessageRepository>(
      () => AudioMessageRepositoryImpl(localDataSource: locator(), remoteDataSource: locator()));
  locator.registerLazySingleton<MediaRepository>(() => MediaRepositoryImpl(localDataSource: locator()));

  //--------------------------------------
  //DataSource
  locator.registerLazySingleton<AudioMessageLocalDataSource>(() =>
      AudioMessageLocalDataSourceImpl(audioPlayer: locator(),audioRecorder: locator()));
  locator.registerLazySingleton<AudioMessageRemoteDataSource>(() =>AudioMessageRemoteDataSourceImpl(dio: locator(), preferences: locator()) );
  locator.registerLazySingleton<MediaLocalDataSource>(() => MediaLocalDataSourceImpl(imagePicker: locator()));
  //--------------------------------------
  //service

  locator.registerLazySingleton(() => PermissionService());
  //--------------------------------------
  //External

  final record = AudioRecorder();
  locator.registerLazySingleton(() => record);
  final tooltipController = SuperTooltipController();
  locator.registerLazySingleton(() => tooltipController);
  final audioPlayer = AudioPlayer();
  locator.registerLazySingleton(() => audioPlayer);
 /*final flutterDownloader = await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );
 locator.registerLazySingleton(() => flutterDownloader);
*/


}
