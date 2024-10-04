/// Interface for authentication services.
///
/// This abstract class defines the contract for authentication-related operations,
/// allowing for different implementations (e.g., Firebase, custom backend).
abstract class IAuthService {
  /// Retrieves the current user's ID.
  ///
  /// Returns a [Future] that completes with the user ID as a [String] if a user is logged in,
  /// or null if no user is authenticated.
  Future<String?> getCurrentUserId();

  /// Checks if the current user is anonymous.
  ///
  /// Returns a [Future] that completes with a [bool] indicating whether the user is anonymous.
  Future<bool> isAnonymous();

  /// Signs in the user anonymously.
  ///
  /// This method creates a new anonymous account or signs in to an existing one.
  /// Returns a [Future] that completes when the operation is finished.
  Future<void> signInAnonymously();

  /// Signs up a new user with email and password.
  ///
  /// [email] The email address for the new account.
  /// [password] The password for the new account.
  /// Returns a [Future] that completes when the sign-up is successful.
  Future<void> signUp(String email, String password);

  /// Signs in an existing user with email and password.
  ///
  /// [email] The email address of the user.
  /// [password] The password of the user.
  /// Returns a [Future] that completes when the sign-in is successful.
  Future<void> signIn(String email, String password);

  /// Signs out the current user.
  ///
  /// Returns a [Future] that completes when the sign-out is successful.
  Future<void> signOut();

  /// Sets up a listener for authentication state changes.
  ///
  /// [listener] A function that will be called with the user ID (or null) when the auth state changes.
  void onAuthStateChange(Function(String?) listener);

  /// Initiates the sign-in process with a one-time password (OTP) sent to the provided email.
  ///
  /// [email] The email address to which the OTP will be sent.
  /// Returns a [Future] that completes when the OTP has been sent successfully.
  Future<void> signInWithOtp(String email);

  /// Verifies the one-time password (OTP) for email sign-in.
  ///
  /// [email] The email address used for the sign-in attempt.
  /// [otp] The one-time password received by the user.
  /// Returns a [Future] that completes with a [bool] indicating whether the OTP was valid.
  Future<bool> verifyOtp(String email, String otp);
}
