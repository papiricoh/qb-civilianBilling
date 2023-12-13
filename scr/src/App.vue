<script setup>
import BillDetails from './components/BillDetails.vue';
import BillCreator from './components/BillCreator.vue';
</script>

<script>
export default {
  data() {
    return {
      visible: false,
      user: null,
      page: "bills",
      canBill: false,


      bills: [
        {id: 1, title: "Police warrant", quantity: 200, paid: false, timestamp: 100000},
        {id: 2, title: "123456789012345678901234567890", quantity: 300, paid: true, timestamp: 1023232320001},
        {id: 1, title: "Police warrant", quantity: 200, paid: false, timestamp: 8003232212312000},
      ]
    };
  },
  mounted() {
    window.addEventListener("message", this.handleNuiMessage);
  },
  
  beforeUnmount() {
    window.removeEventListener("message", this.handleNuiMessage, false);
  },
  methods: {
    handleNuiMessage(event) {
      let data = event.data
      if (data.action == 'openProgram') {
        this.user = data.bills[0].citizenid
        this.bills = data.bills
        this.canBill = data.canBill
        this.openProgram();
      }
    },
    closeProgram() {
      fetch(`https://${GetParentResourceName()}/closeApp`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: JSON.stringify({
            itemId: 'my-item'
          })
      });
      this.visible = false;
    },
    openProgram() {
      //FETCH OPEN PROGRAM

      this.page = "bills";
      this.visible = true;
    },
    billsByOrder() {
      return this.bills.sort((a, b) => a.timestamp < b.timestamp ? 1 : -1);
    }
  },
}
</script>

<template>
  <main v-if="visible">
    <div class="title_row">
      <h2>BILLING</h2>
      <div @click="closeProgram()" class="button"><i class="ph-bold ph-sign-out"></i> EXIT</div>
    </div>
    <hr>
    <div v-if="page == 'bills'" class="bills_container">
      <h3>Your Bills:</h3>
      <BillDetails v-for="bill in billsByOrder()" :user="user" :bill="bill"></BillDetails>
    </div>
    <BillCreator @exit="closeProgram()" v-if="page == 'new_bill'" :user="user"></BillCreator>
    <div @click="page = 'new_bill'" class="new_bill_button" v-if="page == 'bills' && canBill == true">Issue Bill</div>
  </main>
</template>

<style scoped>
.bills_container {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  gap: .4rem;
  overflow-y: scroll;
  height: 50vh;
}
main {
  border-top-right-radius: .8rem;
  border-bottom-right-radius: .8rem;
  height: 70vh;
  width: 60vh;
  border-left: 0;
  padding: .8rem;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  background-color: #13141E;
  color: #6F728B;
}
hr {
  width: 100%;
  border: 2px solid #242539;
  overflow: auto;
}
.title_row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.button {
  padding: .6rem 1.2rem;
  border-radius: .4rem;
  cursor: pointer;
  transition: .4s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: .4rem;
  font-weight: bold;
  font-size: 1.2rem;
}
.button>.ph-bold {
  transform: translateY(1px);
}
.button:hover {
  color: #2D80E7;
  transition: .4s;
}
.button:active {
  color: white;
  transition: .4s;
}
.new_bill_button {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  cursor: pointer;
  font-size: 1.5rem;
  font-weight: bold;
  transition: .4s;
}
.new_bill_button:hover {
  color: #2D80E7;
  transition: .4s;
}
.new_bill_button:active {
  color: white;
  transition: .4s;
}
</style>
