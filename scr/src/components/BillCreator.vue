<script setup>

</script>

<script>
export default {
  data() {
    return {
      selectedPlayer: 0,
      players: [
        {id: 1, first_name: "pedro", last_name: "picapiedra"},
        {id: 2, first_name: "joakin", last_name: "picapiedra"},
        {id: 3, first_name: "pedro", last_name: "picapiedra"},
        {id: 4, first_name: "joakin", last_name: "picapiedra"},
        {id: 5, first_name: "pedro", last_name: "picapiedra"},
        {id: 6, first_name: "joakin", last_name: "picapiedra"},
        {id: 7, first_name: "pedro", last_name: "picapiedra"},
      ]
    };
  },
  props: {
    user: Object,
  },
  methods: {
    sendBill() {
      //POST SEND BILL
      this.$emit('exit');
    }
  }
}
</script>

<template>
  <div class="bills_container">
    <label for="title">Title:</label>
    <input id="title" type="text">
    <br>
    <label for="quantity">Quantity:</label>
    <input id="quantity" type="number">
    <br>
    <br>
    <label>People near:</label>
    <div class="near_people_container">
      <div class="playerFor" v-for="player in players">
        <div v-if="selectedPlayer != 0 && selectedPlayer == player.id" class="people_box selected">
          <i class="ph-bold ph-user"></i>{{ player.first_name + " " + player.last_name }}
        </div>
        <div @click="selectedPlayer = player.id" v-else class="people_box">
          <i class="ph-bold ph-user"></i>{{ player.first_name + " " + player.last_name }}
        </div>
      </div>
    </div>
    <br>
    <div @click="sendBill()" class="button">Send Bill</div>
  </div>
</template>

<style scoped>
input {
  height: 2rem;
  font-size: larger;
  font-family: 'Bree Serif', serif;
  padding: .4rem;
  border-radius: .4rem;
  border: 0;
  background-color: #242539;;
  color: #6F728B;
}
input:focus-visible {
  outline: 0;
}
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
label {
  font-size: 1.4rem;
}
.bills_container {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  gap: .4rem;
  height: 50vh;
  padding: 1rem;
}
.people_box {
  padding: .4rem;
  display: flex;
  align-items: center;
  gap: .4rem;
  cursor: pointer;
  background-color: #242539;
  width: fit-content;
  height: fit-content;
  font-size: 1.2rem;
  border-radius: .4rem;
  transition: .4s;
}
.playerFor {
  display: flex;
  align-items: center;
  width: fit-content;
  height: fit-content;
}
.people_box:hover {
  background-color: #13141E;
  transition: .4s;
  color: #6F728B;
}
.people_box:active {
  background-color: #13141E;
  transition: .4s;
  color: #6F728B;
}
.button {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  cursor: pointer;
  font-size: 1.5rem;
  font-weight: bold;
  transition: .4s;
  margin: 0 18vh;
}
.button:hover {
  color: #2D80E7;
  transition: .4s;
}
.button:active {
  color: white;
  transition: .4s;
}
.near_people_container {
  background-color: #171826;
  height: 14rem;
  border-radius: .4rem;
  padding: .4rem;
  gap: .4rem;
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  box-sizing: border-box;
  overflow-y: scroll;
}
.selected {
  background-color: #6F728B;
  color: #171826;
}
</style>
