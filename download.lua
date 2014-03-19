local create = coroutine.create
local yield = coroutine.yield
local resume = coroutine.resume
local tcp = ngx.socket.tcp

function download(host, file)
    local tcpsock = tcp()
    local conn, err = tcpsock:connect(host, 80)
    local count = 0
    tcpsock:send("GET " .. file .. " HTTP/1.1\r\nHost: 10.25.14.174\r\nConnection: closed\r\n\r\n")

    while true do
        local s, status, partial = receive(tcpsock)
        count = count + #(s or partial)
        if status == "closed" then break end
    end

    tcpsock:close()
    ngx.say(file, ' ', count)
end

function receive(connection)
    connection:settimeout(1000)
    local s, status, partial = connection:receive("*l")
    if status == "timeout" then
        yield(connection)
    end
    return s or partial, status
end

threads = {}

function get (host, file)

    local co = create(function ()
        download(host, file)
    end)

    table.insert(threads, co)
end

function dispatch ()
    local i = 1
    while true do
        if threads[i] == nil then
            if threads[1] == nil then break end
            i = 1
        end
        local status, res = resume(threads[i])
        if not res then
            table.remove(threads, i)
        else
            i = i + 1
        end
    end
end

-- main

local host = "xx.xx.xx.xx"

get(host, "/test.txt")
get(host, "/test1.txt")
get(host, "/test2.txt")
get(host, "/test3.txt")

dispatch()
