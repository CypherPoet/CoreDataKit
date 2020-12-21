import Foundation


// 📝 More useful NSPredicate tips: https://nspredicate.xyz/


extension NSPredicate {

    /// Constants to help clarify the format specifiers
    /// documented [here](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html)
    /// a long time ago (and possibly not completely 😆).
    public enum FormatSpecifiers {

        /// string value returned by an object's `description` property.
        public static let object = "%@"


        /// Signed 32-bit integer
        public static let integer = "%i"


        /// Unsigned 32-bit integer
        public static let unsignedInteger = "%u"


        /// string value with the percent symbol ("%") appended
        public static let percent = "%%"


        /// Unsigned 32-bit integer, printed in hexadecimal
        /// using the digits 0–9 and lowercase a–f.
        public static let unsignedIntegerHexLowercase = "%x"


        /// Unsigned 32-bit integer printed in hexadecimal using
        /// the digits 0–9 and uppercase A–F.
        public static let unsignedIntegerHexUppercase = "%X"


        /// Unsigned 32-bit integer, printed in octal.
        public static let unsignedIntegerOctal = "%o"


        /// 64-bit floating-point number (double), printed in decimal notation.
        ///
        /// Edge cases:
        /// - Infinity: Produces "inf", "infinity"
        /// - nan: Produces "nan".
        public static let decimalLowercase = "%f"


        /// 64-bit floating-point number (double), printed in uppercase decimal notation.
        ///
        /// Edge cases:
        /// - Infinity: Produces "INF", "INFINITY"
        /// - nan: Produces "NAN".
        public static let decimalUppercase = "%F"


        /// 64-bit floating-point number (double), printed in scientific notation using
        /// a lowercase `e` to introduce the exponent.
        public static let scientificExponentLowercase = "%e"


        /// 64-bit floating-point number (double), printed in scientific notation
        /// using an uppercase `E` to introduce the exponent.
        public static let scientificExponentUppercase = "%E"


        /// 64-bit floating-point number (double), printed in the style of `%e` if
        /// the exponent is less than –4 or greater than or equal to the precision.
        /// Otherwise, the value us printed in the style of `%f`.
        public static let scientificExponentLowercasePrecision = "%g"


        /// 64-bit floating-point number (double), printed in the style of `%E` if
        /// the exponent is less than –4 or greater than or equal to the precision.
        /// Otherwise, the value us printed in the style of `%f`.
        public static let scientificExponentUppercasePrecision = "%G"


        ///  8-bit unsigned character (unsigned char).
        public static let unsigned8BitChar = "%c"


        /// 16-bit UTF-16 code unit (unichar).
        public static let utf16CodeUnit = "%C"


        /// Null-terminated array of 8-bit unsigned characters.
        public static let nullTerminated8BitUnsignedCharArray = ""


        /// 64-bit floating-point number (double), printed in scientific notation with a leading 0x
        /// and one hexadecimal digit before the decimal point using a lowercase p
        /// to introduce the exponent.
        public static let scientificHexPowerLowercase = "%a"


        /// 64-bit floating-point number (double), printed in scientific notation with a leading 0X
        /// and one hexadecimal digit before the decimal point using an
        /// uppercase P to introduce the exponent.
        public static let scientificHexPowerUppercase = "%A"

    }
}


