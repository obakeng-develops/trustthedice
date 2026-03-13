import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = {
    gameId: Number,
    playerId: Number,
    turnId: Number
  }

  connect() {
    if (!this.gameIdValue) return

    this.subscription = consumer.subscriptions.create(
      { channel: "BuzzChannel", game_id: this.gameIdValue },
      {}
    )
  }

  disconnect() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
  }

  send() {
    if (!this.subscription) return
    if (!this.playerIdValue || !this.turnIdValue) return

    this.subscription.perform("buzz", {
      player_id: this.playerIdValue,
      turn_id: this.turnIdValue
    })
  }
}
