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

let canGoTo (path:List<String>) (name:String) =
    let r = new Regex("[A-Z]")
    if r.IsMatch (name)
        then true
        else not (List.contains name path)

let doesNotRepeatSmallCave path =
    let r = new Regex("[a-z]")
    match path |> List.filter r.IsMatch
               |> List.countBy id
               |> List.map snd
               |> List.tryFind (fun e -> e > 1) with
        | None -> true
        | _ -> false

let canGoToWithOneRevisit (path:List<String>) (name:String) =
    if canGoTo path name
        then true
        else match name with
                | "start" -> false
                | _ -> doesNotRepeatSmallCave path

let pickPaths (map:Map<String,List<String>>) (name:String) (path:List<String>) reachabilityCondition =
    List.filter (reachabilityCondition path) map[name]

let rec doCountPaths (map:Map<String,List<String>>) (name:String) (path:List<String>) reachabilityCondition =
    match name with
        | "end" -> 1
        | _ -> List.sum ([for next in pickPaths map name (name :: path) reachabilityCondition -> doCountPaths map next (name :: path) reachabilityCondition])
let countPaths map nextPicker =
    doCountPaths map "start" [] nextPicker

let paths = parseLines (Seq.toList (readlines ()))
printfn "%d" (countPaths paths canGoToWithOneRevisit)
