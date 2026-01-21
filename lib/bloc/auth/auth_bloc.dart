import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/bloc/auth/auth_event.dart';
import 'package:simple_alarm/bloc/auth/auth_state.dart';
import 'package:simple_alarm/service/auth/storage_service.dart';

import 'package:simple_alarm/service/auth/api_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StorageService _storageService;
  final ApiService _apiService;

  AuthBloc({
    required StorageService storageService,
    required ApiService apiService,
  })
      : _storageService = storageService,
        _apiService = apiService,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await _apiService.login(event.username, event.password);
      add(LoggedIn(token: token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _apiService.register(event.username, event.password);
      // After registration, automatically log in
      final token = await _apiService.login(event.username, event.password);
      add(LoggedIn(token: token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = await _storageService.getToken();
    if (token != null) {
      emit(Authenticated(token));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _storageService.saveToken(event.token);
    emit(Authenticated(event.token));
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _storageService.deleteToken();
    emit(Unauthenticated());
  }
}
