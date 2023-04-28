import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_appl/Layout/SocialApp/socialStates.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(InitialStates());
}
