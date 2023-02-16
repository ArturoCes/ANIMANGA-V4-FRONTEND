part of 'mangas_bloc.dart';

abstract class MangasEvent extends Equatable {
  const MangasEvent();

  @override
  List<Object> get props => [];
}

class FindAllMangas extends MangasEvent {
  const FindAllMangas();

  @override
  List<Object> get props => [];
}