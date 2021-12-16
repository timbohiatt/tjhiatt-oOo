<template>
  <header class="relative flex items-center justify-center h-screen mb-12 overflow-hidden">
    <div
      class="relative z-30 p-3 px-12 text-2xl text-white bg-gray-300 bg-opacity-30 rounded-xl"
    >
      On Leave!
    </div>
    <video
      autoplay
      loop
      muted
      class="absolute z-10 w-auto min-w-full min-h-full max-w-none"
    >
      <source
        src="https://assets.mixkit.co/videos/preview/mixkit-set-of-plateaus-seen-from-the-heights-in-a-sunset-26070-large.mp4"
        type="video/mp4"
      />
      Your browser does not support the video tag.
    </video>
  </header>
</template>

<script>
export default {
  name: 'Home',
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
