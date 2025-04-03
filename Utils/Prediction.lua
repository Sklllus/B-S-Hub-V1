--//
--// Prediction Made By xS_Killus
--//

local Workspace = game:GetService("Workspace")

local Module = {}

local EPS = 1e-9

local function IsZero(d)
    return (d > -EPS and d < EPS)
end

local function CubeRoot(x)
    return (x > 0) and math.pow(x, (1 / 3)) or -math.pow(math.abs(x), (1 / 3))
end

local function SolveQuadric(c0, c1, c2)
    local s0, s1
    local p, q, D

    p = c1 / (2 * c0)
    q = c2 / c0
    D = p * p - q

    if IsZero(D) then
        s0 = -p

        return s0
    elseif (D < 0) then
        return
    else
        local SqrtD = math.sqrt(D)

        s0 = SqrtD - p
        s1 = -SqrtD - p

        return s0, s1
    end
end

local function SolveCubic(c0, c1, c2, c3)
    local s0, s1, s2
    local Num, Sub
    local A, B, C
    local SqA, p, q
    local CbP, D

    A = c1 / c0
    B = c2 / c0
    C = c3 / c0
    SqA = A * A
    p = (1 / 3) * (-(1 / 3) * SqA + B)
    q = 0.5 * ((2 / 27) * A * SqA - (1 / 3) * A * B + C)
    CbP = p * p * p
    D = q * q + CbP

    if IsZero(D) then
        if IsZero(q) then
            s0 = 0
            Num = 1
        else
            local u = CubeRoot(-q)

            s0 = 2 * u
            s1 = -u
            Num = 2
        end
    elseif (D < 0) then
        local Phi = (1 / 3) * math.acos(-q / math.sqrt(-CbP))
        local t = 2 * math.sqrt(-p)

        s0 = t * math.cos(Phi)
        s1 = -t * math.cos(Phi + math.pi / 3)
        s2 = -t * math.cos(Phi - math.pi / 3)
        Num = 3
    else
        local SqrtD = math.sqrt(D)
        local u = CubeRoot(SqrtD - q)
        local v = -CubeRoot(SqrtD + q)

        s0 = u + v
        Num = 1
    end

    Sub = (1 / 3) * A

    if (Num > 0) then
        s0 = s0 - Sub
    end

    if (Num > 1) then
        s1 = s1 - Sub
    end

    if (Num > 2) then
        s2 = s2 - Sub
    end

    return s0, s1, s2
end

function Module.SolveQuartic(c0, c1, c2, c3, c4)
    local s0, s1, s2, s3

    local Coeffs = {}

    local z, u, v, sub
    local A, B, C, D
    local SqA, p, q, r
    local num

    A = c1 / c0
    B = c2 / c0
    C = c3 / c0
    D = c4 / c0
    SqA = A * A
    p = -0.375 * SqA + B
    q = 0.125 * SqA * A - 0.5 * A * B + C
    r = -(3 / 256) * SqA * SqA + 0.0625 * SqA * B - 0.25 * A * C + D

    if IsZero(r) then
        Coeffs[3] = q
        Coeffs[2] = p
        Coeffs[1] = 0
        Coeffs[0] = 1

        local Results = {
            SolveCubic(Coeffs[0], Coeffs[1], Coeffs[2], Coeffs[3])
        }

        num = #Results

        s0, s1, s2 = Results[1], Results[2], Results[3]
    else
        Coeffs[3] = 0.5 * r * p - 0.125 * q * q
        Coeffs[2] = -r
        Coeffs[1] = -0.5 * p
        Coeffs[0] = 1

        s0, s1, s2 = SolveCubic(Coeffs[0], Coeffs[1], Coeffs[2], Coeffs[3])

        z = s0
        u = z * z - r
        v = 2 * z - p

        if IsZero(u) then
            u = 0
        elseif (u > 0) then
            u = math.sqrt(u)
        else
            return
        end

        if IsZero(v) then
            v = 0
        elseif (v > 0) then
            v = math.sqrt(v)
        else
            return
        end

        Coeffs[2] = z - u
        Coeffs[1] = q < 0 and -v or v
        Coeffs[0] = 1

        do
            local Results = {
                SolveQuadric(Coeffs[0], Coeffs[1], Coeffs[2])
            }

            num = #Results
            s0, s1 = Results[1], Results[2]
        end

        Coeffs[2] = z + u
        Coeffs[1] = q < 0 and v or -v
        Coeffs[0] = 1

        if (num == 0) then
            local Results = {
                SolveQuadric(Coeffs[0], Coeffs[1], Coeffs[2])
            }

            num = num + #Results

            s0, s1 = Results[1], Results[2]
        end

        if (num == 1) then
            local Results = {
                SolveQuadric(Coeffs[0], Coeffs[1], Coeffs[2])
            }

            num = num + #Results

            s1, s2 = Results[1], Results[2]
        end

        if (num == 2) then
            local Results = {
                SolveQuadric(Coeffs[0], Coeffs[1], Coeffs[2])
            }

            num = num + #Results

            s2, s3 = Results[1], Results[2]
        end
    end

    sub = 0.25 * A

    if (num > 0) then
        s0 = s0 - sub
    end

    if (num > 1) then
        s1 = s1 - sub
    end

    if (num > 2) then
        s2 = s2 - sub
    end

    if (num > 3) then
        s3 = s3 - sub
    end

    return {
        s3,
        s2,
        s1,
        s0
    }
end

function Module.SolveTrajectory(origin, projectileSpeed, gravity, targetPos, targetVelocity, playerGravity, playerHeight, playerJump, params)
    local Disp = targetPos - origin

    local p, q, r = targetVelocity.X, targetVelocity.Y, targetVelocity.Z
    local h, j, k = Disp.X, Disp.Y, Disp.Z
    local l = -.5 * gravity

    if math.abs(q) > 0.01 and playerGravity and playerGravity > 0 then
        local ESTTime = (Disp.Magnitude / projectileSpeed)

        local OrigQ = q
        local OrigJ = j

        for i = 1, 100 do
            q -= (.5 * playerGravity) * ESTTime

            local Velocity = targetVelocity * 0.016

            local Ray = Workspace.Raycast(Workspace, Vector3.new(targetPos.X, targetPos.Y, targetPos.Z), Vector3.new(Velocity.X, (q * ESTTime) - playerHeight, Velocity.Z), params)

            if Ray then
                local NewTarget = Ray.Position + Vector3.new(0, playerHeight, 0)

                ESTTime -= math.sqrt(((targetPos - NewTarget).Magnitude * 2) / playerGravity)

                targetPos = NewTarget

                j = (targetPos - origin).Y
                q = 0

                break
            else
                break
            end
        end
    end

    local Solutions = Module.SolveQuartic(l * l, -2 * q * 1, q * q - 2 * j * 1 - projectileSpeed * projectileSpeed + p * p + r * r, 2 * j * q + 2 * h * p + 2 * k * r, j * j + h * h + k * k)

    if Solutions then
        local PosRoots = table.create(2)

        for _, v in Solutions do
            if v > 0 then
                table.insert(PosRoots, v)
            end
        end

        PosRoots[1] = PosRoots[1]

        if PosRoots[1] then
            local t = PosRoots[1]
            local d = (h + p * t) / t
            local e = (j  + q * t - l * t * t) / t
            local f = (k + r * t) / t

            return origin + Vector3.new(d, e, f)
        end
    elseif gravity == 0 then
        local t = (Disp.Magnitude / projectileSpeed)
        local d = (h + p * t) / t
        local e = (j + q * t - l * t * t) / t
        local f = (k + r * t) / t

        return origin + Vector3.new(d, e, f)
    end
end

return Module
