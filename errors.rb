class WrongPieceError < StandardError
end

class BadMoveError < StandardError
end

class NoMoveError < StandardError
end

class CheckError < StandardError
end

class MovingIntoCheckError < StandardError
end

class CheckMateError < StandardError
end

class CastlingException < StandardError
end

class BadCastleError < StandardError
end
