// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import {pages} from "./data/pages"

class PageChannel {
  constructor(socket){
    this.channel = socket.channel("pages", {token: "something"})
    this.channel.on("new_msg", msg => console.log("Got message", msg))
    this.channel.join()
     .receive("ok", (data) => console.log("catching up", data) )
     .receive("error", (reason) => console.log("failed join", reason) )
     .receive("timeout", () => console.log("Networking issue. Still waiting...") )

    this.channel.on('page_new', (message) => {
      console.log({ type: 'MESSAGE_CREATED', message });
    });
  }
  save(changes) {
    this.channel.push("new", changes)
  }
}

var pageChannel = new PageChannel(socket);

pageChannel.save(pages[0])
