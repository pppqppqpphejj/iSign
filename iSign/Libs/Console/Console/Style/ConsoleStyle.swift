/**
    Different default console styles.
 
    Console implementations can choose which
    colors they use for the variouis styles.
*/
public enum ConsoleStyle {
    case plain
    case success
    case info
    case warning
    case error
    case custom(ConsoleColor)
}
