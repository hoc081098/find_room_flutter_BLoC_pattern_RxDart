enum BookmarkIconState { hide, showSaved, showNotSaved, loading }

abstract class RoomDetailMessage {}

class AddSavedSuccessMessage implements RoomDetailMessage {
  const AddSavedSuccessMessage();
}

class RemoveSavedSuccessMessage implements RoomDetailMessage {
  const RemoveSavedSuccessMessage();
}

class AddOrRemovedSavedErrorMessage implements RoomDetailMessage {
  final RoomDetailError error;

  const AddOrRemovedSavedErrorMessage(this.error);
}

abstract class RoomDetailError {}

class UnauthenticatedError implements RoomDetailError {
  const UnauthenticatedError();
}

class UnknownError implements RoomDetailError {
  final error;

  UnknownError(this.error);
}
