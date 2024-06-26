final RegExp emailValidationRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
// final RegExp passwordValidationRegex =
//     RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");
final RegExp passwordValidationRegex = RegExp(r"^.{6,}$");
// final RegExp nameValidationRegex = RegExp(r"\b([A-Z][-,a-z. ']+[ ]*)+");
final RegExp nameValidationRegex = RegExp('/./');
const String placeholderPFP =
    'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
