from queue import PriorityQueue

inputFile = open("example.txt", "r")

input = []

i = 0
for line in inputFile:
    input.append([])
    for char in line:
        if char != '\n':
            input[i].append(ord(char))
    i += 1

positionOfS = (0, 0)
positionOfE = (0, 0)
y = 0
x = 0
for line in input:
    for cell in line:
        if cell == ord('S'):
            positionOfS = (x, y)
            input[y][x] = ord('a')
        elif cell == ord('E'):
            positionOfE = (x, y)
            input[y][x] = ord('z')
        x += 1
    y += 1
    x = 0

def shortestPath(path, bounds, start, end):
    frontier = PriorityQueue()
    frontier.put(start, 0)
    came_from = dict()
    cost_so_far = dict()
    came_from[start] = None
    cost_so_far[start] = 0

    while not frontier.empty():
        current = frontier.get()
        print("currrent", current)
        
        if current == end:
            print("End", cost_so_far[current])
            break

        for next in neighbours(path, current, bounds):
            new_cost = cost_so_far[current] + 1
            print("next", next)
            if next not in cost_so_far or new_cost < cost_so_far[next]:
                cost_so_far[next] = new_cost
                priority = new_cost
                frontier.put(next, priority)
                came_from[next] = current

    # print(frontier.empty())

    return came_from[end]

def neighbours(path, pos, bounds):
    neighbours = []
    if pos[0] != 0             and canGoTo(path, pos, (pos[0] - 1, pos[1])):
        neighbours.append((pos[0] - 1, pos[1]))
    if pos[0] != bounds[0] - 1 and canGoTo(path, pos, (pos[0] + 1, pos[1])):
        neighbours.append((pos[0] + 1, pos[1]))
    if pos[1] != 0             and canGoTo(path, pos, (pos[0], pos[1] - 1)):
        neighbours.append((pos[0], pos[1] - 1))
    if pos[1] != bounds[1] - 1 and canGoTo(path, pos, (pos[0], pos[1] + 1)):
        neighbours.append((pos[0], pos[1] + 1))

    return neighbours

# Retuns whether the `pos2` is at max one step higher/lower than `pos`
def canGoTo(path, pos, pos2):
    posV = path[pos[1]][pos[0]]
    pos2V = path[pos2[1]][pos2[0]]
    # print("can go to ", pos, " ", pos2, posV -1 <= pos2V <= posV - 1)
    return posV - 1 <= pos2V <= posV + 1

print(shortestPath(input, (len(input[0]), len(input)), positionOfS, positionOfE))
# print(len(input[0]))
# print(len(input))
