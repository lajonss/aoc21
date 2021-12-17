open System
open System.Text.RegularExpressions

let rec readlines () = seq {
    let line = Console.ReadLine()
    if line <> null then
        yield line
        yield! readlines ()
}

let addPath (map:Map<String,List<String>>, key:String, value:String) =
    match map.TryFind key with
        | None -> map.Add (key, [value])
        | Some list -> map.Add(key, value::list)
let parseLine (map, line:String) =
    let split = line.Split "-"
    let map1 = addPath (map, split[0], split[1])
    addPath (map1, split[1], split[0])
let rec parseLineNext map lines =
    match lines with
        | [] -> map
        | line :: restOfLines -> parseLineNext (parseLine (map, line)) restOfLines
let parseLines lines = parseLineNext Map[] lines

let printMap (map:Map<String,List<String>>) =
    for kvp in map do
        printfn "%s: %A" kvp.Key kvp.Value

let canGoTo (path:Set<String>) (name:String) =
    let r = new Regex("[A-Z]")
    if r.IsMatch (name)
        then true
        else not (path.Contains (name))

let pickPaths (map:Map<String,List<String>>) (name:String) (path:Set<String>) =
    List.filter (canGoTo path) map[name]

let rec doCountPaths (map:Map<String,List<String>>) (name:String) (path:Set<String>) =
    match name with
        | "end" -> 1
        | _ -> List.sum ([for next in pickPaths map name (path.Add name) -> doCountPaths map next (path.Add name)])
let countPaths map =
    doCountPaths map "start" Set[]

let paths = parseLines (Seq.toList (readlines ()))
printfn "%d" (countPaths paths)
