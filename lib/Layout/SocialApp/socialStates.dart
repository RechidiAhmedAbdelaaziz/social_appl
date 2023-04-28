abstract class SocialStates {}

class InitialStates extends SocialStates {}

class GetUserLoadingState extends SocialStates {}
class GetUserSuccessState extends SocialStates {}
class GetUserErrorState extends SocialStates {
  String error;
  GetUserErrorState(this.error);
}
