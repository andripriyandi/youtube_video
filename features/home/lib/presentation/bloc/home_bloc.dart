import 'package:common/utils/error/failure_response.dart';
import 'package:common/utils/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:home/presentation/bloc/bloc.dart';
import 'package:video/domain/entities/youtube_video_entity.dart';
import 'package:video/domain/usecases/get_video_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetVideoUseCase getVideoUseCase;

  HomeBloc({required this.getVideoUseCase})
      : super(HomeState(statusYouTubeVideo: ViewData.initial())) {
    on<SearchVideo>(_mapSearchEventToState);
  }

  void _mapSearchEventToState(
      SearchVideo event, Emitter<HomeState> emit) async {
    emit(HomeState(statusYouTubeVideo: ViewData.loading(message: 'Loading')));
    final response = await getVideoUseCase.call(event.query);

    response.fold(
      (l) => _onFailure(l, emit),
      (r) => _onSuccess(r, emit),
    );
  }

  void _onSuccess(YouTubeVideoEntity? data, Emitter<HomeState> emit) async {
    final videos = data?.items ?? [];
    if (videos.isEmpty) {
      emit(HomeState(statusYouTubeVideo: ViewData.noData(message: 'No Data')));
    } else {
      emit(HomeState(statusYouTubeVideo: ViewData.loaded(data: data)));
    }
  }

  void _onFailure(FailureResponse failure, Emitter<HomeState> emit) async {
    emit(HomeState(
        statusYouTubeVideo:
            ViewData.error(message: failure.errorMessage, failure: failure)));
  }
}
