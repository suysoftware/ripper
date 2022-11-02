class RipperUser {
  //user uid
  late String userUid;
  //user name
  late String userName;
  //user email
  late String userEmail;
  //user password
  late String userPassword;
  //User Can Get Token or Time
  late bool userFirstVerify;
  //User Can Get/Send Token or Time
  late bool userSecondVerify;
  // User's token value
  late int userToken;
  //User Profile Picture
  late String userPhoto;
  //User Phone
  late String userPhone;

  RipperUser();

  RipperUser.withInfo(
      this.userUid,
      this.userName,
      this.userEmail,
      this.userPassword,
      this.userFirstVerify,
      this.userSecondVerify,
      this.userToken,
      this.userPhoto,

      this.userPhone);
}
