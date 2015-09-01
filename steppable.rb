module Steppable
  def get_paths
    paths = []

    move_transforms.each do |transform|
      path = []
      ty, tx = position
      ty += transform[0]
      tx += transform[1]

      if board.valid_position?([ty, tx])
        path << [ty, tx]
        ty += transform[0]
        tx += transform[1]
      end

      paths << path
    end

    paths
  end
end
