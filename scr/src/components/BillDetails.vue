<script setup>

</script>

<script>
export default {
  data() {
    return {
      
    };
  },
  props: {
    bill: Object,
    user: Text,
  },
  methods: {
    payBill() {
      //TODO FETCH PAY
      fetch(`https://${GetParentResourceName()}/pay`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
          bill: this.bill,
          citizenid: this.user
        })
      }).then(response => response.json()).then(data => {
        if (data) {
          console.log("Pago realizado con éxito");
          this.bill.paid = true;
        } else {
          console.log("Fondos insuficientes");
        }
      }).catch(error => {
        console.error('Error:', error);
      });
    }
  }
}
</script>

<template>
  <div class="billDetails">
    <div style="overflow: hidden;">{{ bill.title }}</div>
    <div>{{ new Date(bill.timestamp).toLocaleDateString() }}</div>
    <div>${{ bill.quantity }}</div>
    <div v-if="bill.paid">Paid</div>
    <div class="pay" v-else @click="payBill()">Pay</div>
  </div>
</template>

<style scoped>
.pay {
  border-radius: .4rem;
  cursor: pointer;
  transition: .4s;
  gap: .4rem;
  font-weight: bold;
  color: #2D80E7;
  transition: .4s;
}
.pay:hover {
  color: white;
  transition: .4s;
}
.pay:active {
  color: grey;
  transition: .4s;
}
.billDetails {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  align-items: center;
  width: 100%;
  box-sizing: border-box;
  height: 3rem;
  background-color: #171826;
  border-radius: .4rem;
  padding: .4rem;
  gap: .4rem;
}
</style>
