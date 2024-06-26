final RegExp emailValidationRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
// final RegExp passwordValidationRegex =
//     RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
final RegExp passwordValidationRegex = RegExp(r"^.{6,}$");
final RegExp nameValidationRegex = RegExp(r"\b([A-Z][-,a-z. ']+[ ]*)+");
final RegExp urlValidationRegex =
    RegExp(r"^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$");
