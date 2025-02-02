abstract class AuthFailure {
  const AuthFailure();

  // Factory constructors for each failure type
  const factory AuthFailure.serverError() = _ServerError;
  const factory AuthFailure.invalidPhoneNumber() = _InvalidPhoneNumber;
  const factory AuthFailure.tooManyRequests() = _TooManyRequests;
  const factory AuthFailure.deviceNotSupported() = _DeviceNotSupported;
  const factory AuthFailure.smsTimeout() = _SmsTimeout;
  const factory AuthFailure.sessionExpired() = _SessionExpired;
  const factory AuthFailure.invalidVerificationCode() =
      _InvalidVerificationCode;
  const factory AuthFailure.invalidFormat() = _InvalidFormat;
  const factory AuthFailure.genericError(String e) = _GenericError;

  // Override toString for better debugging
  @override
  String toString() {
    if (this is _ServerError) {
      return 'AuthFailure: Server Error';
    } else if (this is _InvalidPhoneNumber) {
      return 'AuthFailure: Invalid Phone Number';
    } else if (this is _TooManyRequests) {
      return 'AuthFailure: Too Many Requests';
    } else if (this is _DeviceNotSupported) {
      return 'AuthFailure: Device Not Supported';
    } else if (this is _SmsTimeout) {
      return 'AuthFailure: SMS Timeout';
    } else if (this is _SessionExpired) {
      return 'AuthFailure: Session Expired';
    } else if (this is _InvalidVerificationCode) {
      return 'AuthFailure: Invalid Verification Code';
    } else if (this is _InvalidFormat) {
      return 'AuthFailure: Invalid Format';
    } else if (this is _GenericError) {
      return 'AuthFailure: ${(this as _GenericError).message}';
    }
    return 'AuthFailure: Unknown';
  }

  // Override equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    // Handle _GenericError separately
    if (this is _GenericError && other is _GenericError) {
      return (this as _GenericError).message == other.message;
    }

    return true; // All other instances are equal if they are of the same type
  }

  @override
  int get hashCode {
    if (this is _GenericError) {
      return (this as _GenericError).message.hashCode;
    }
    return runtimeType.hashCode;
  }
}

// Subclasses for each failure type
class _ServerError extends AuthFailure {
  const _ServerError();
}

class _InvalidPhoneNumber extends AuthFailure {
  const _InvalidPhoneNumber();
}

class _TooManyRequests extends AuthFailure {
  const _TooManyRequests();
}

class _DeviceNotSupported extends AuthFailure {
  const _DeviceNotSupported();
}

class _SmsTimeout extends AuthFailure {
  const _SmsTimeout();
}

class _SessionExpired extends AuthFailure {
  const _SessionExpired();
}

class _InvalidVerificationCode extends AuthFailure {
  const _InvalidVerificationCode();
}

class _InvalidFormat extends AuthFailure {
  const _InvalidFormat();
}

class _GenericError extends AuthFailure {
  final String message;
  const _GenericError(this.message);
}
