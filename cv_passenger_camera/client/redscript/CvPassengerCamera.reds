// Passenger Q uses the same vehicleRequestCameraPerspectiveEvent cycle the
// driver gets (FPP -> TPPClose -> TPPMedium -> TPPFar). Open77VehicleCamera.reds
// already unlocks that path for managed vehicles when ToggleVehCamera reaches
// VehicleTransition; this file also catches the action on the player so a
// passenger seat that never enters that transition still gets the real cams.

public static func CvPassengerCameraIsLocalPassenger(player: ref<PlayerPuppet>) -> Bool {
  let game: GameInstance;
  let vehicle: ref<VehicleObject>;
  if !IsDefined(player) {
    return false;
  };
  game = player.GetGame();
  if player != GetPlayer(game) {
    return false;
  };
  vehicle = player.GetMountedVehicle();
  if !IsDefined(vehicle) {
    return false;
  };
  return !VehicleComponent.IsDriver(game, player);
}

public static func CvPassengerCameraCycle(player: ref<PlayerPuppet>) -> Void {
  let vehicle: ref<VehicleObject>;
  let evt: ref<vehicleRequestCameraPerspectiveEvent>;
  if !IsDefined(player) {
    return;
  };
  if StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"VehicleCombatNoInterruptions")
    || StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"VehicleScene") {
    return;
  };
  vehicle = player.GetMountedVehicle();
  if !IsDefined(vehicle) || !IsDefined(vehicle.GetCameraManager()) {
    return;
  };
  evt = new vehicleRequestCameraPerspectiveEvent();
  switch vehicle.GetCameraManager().GetActivePerspective() {
    case vehicleCameraPerspective.FPP:
      evt.cameraPerspective = vehicleCameraPerspective.TPPClose;
      break;
    case vehicleCameraPerspective.TPPClose:
      evt.cameraPerspective = vehicleCameraPerspective.TPPMedium;
      break;
    case vehicleCameraPerspective.TPPMedium:
      evt.cameraPerspective = vehicleCameraPerspective.TPPFar;
      break;
    default:
      evt.cameraPerspective = vehicleCameraPerspective.FPP;
  };
  player.QueueEvent(evt);
}

@wrapMethod(PlayerPuppet)
protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
  if Equals(ListenerAction.GetName(action), n"ToggleVehCamera")
    && Equals(ListenerAction.GetType(action), gameinputActionType.BUTTON_PRESSED)
    && CvPassengerCameraIsLocalPassenger(this) {
    CvPassengerCameraCycle(this);
    ListenerActionConsumer.Consume(consumer);
  };
  return wrappedMethod(action, consumer);
}
