# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create a sample user if it doesn't exist
User.find_or_create_by!(email_address: 'angler@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

user = User.find_or_create_by!(email_address: 'historian@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
end

# Sample ancient history posts
posts_data = [
  {
    title: "The Mystery of the Lost City of Atlantis",
    content: "Plato's dialogues Timaeus and Critias describe Atlantis as a powerful and advanced civilization that existed 9,000 years before his time. According to the story, Atlantis was a large island located in the Atlantic Ocean that was larger than Libya and Asia combined. The city was said to have been built by Poseidon himself and was protected by concentric rings of water and land. The Atlanteans were initially a virtuous people, but they eventually became greedy and imperialistic, leading to their downfall when they attempted to conquer Athens.",
    region: "Mediterranean",
    url: "https://www.nationalgeographic.com/history/article/atlantis"
  },
  {
    title: "The Building of the Great Pyramid of Giza",
    content: "The Great Pyramid of Giza was built around 2560 BCE during the reign of Pharaoh Khufu. It took approximately 20 years to build and required about 2.3 million stone blocks, each weighing between 2.5 to 15 tons. The precision of its construction is remarkable - the base is level to within just 2.1cm, and its sides are aligned to the cardinal points with an accuracy of up to 0.15 degrees. The methods used to construct this massive monument continue to be debated by historians and engineers today.",
    region: "Egypt",
    url: "https://www.britannica.com/topic/Pyramids-of-Giza"
  },
  {
    title: "The Fall of Constantinople",
    content: "On May 29, 1453, the Byzantine Empire's capital fell to the Ottoman Turks, marking the end of the Roman Empire's last remnant. The siege lasted 53 days, with Sultan Mehmed II's forces using innovative tactics and technology, including massive cannons that could fire 600-pound stones. The city's fall marked the end of the medieval period and the beginning of the Renaissance, as many Greek scholars fled to Italy with their knowledge and manuscripts.",
    region: "Mediterranean",
    url: "https://www.worldhistory.org/article/1180/the-fall-of-constantinople"
  },
  {
    title: "Cleopatra: The Last Pharaoh of Egypt",
    content: "Contrary to popular depiction, Cleopatra VII was more renowned for her intellect than her beauty. She spoke nine languages and was educated in mathematics, philosophy, oratory, and astronomy. As the last active ruler of the Ptolemaic Kingdom of Egypt, she aligned herself first with Julius Caesar and later with Mark Antony to protect Egypt's independence. Her reign marked the end of both the Ptolemaic dynasty and the Hellenistic period.",
    region: "Egypt",
    url: "https://www.history.com/topics/ancient-egypt/cleopatra"
  },
  {
    title: "The Terracotta Army of Qin Shi Huang",
    content: "Discovered in 1974 by local farmers in Xi'an, China, the Terracotta Army consists of over 8,000 soldiers, 130 chariots with 520 horses, and 150 cavalry horses. Each warrior has unique facial features, suggesting they were modeled after real soldiers. The army was built to protect Emperor Qin Shi Huang in the afterlife and took over 700,000 workers and craftsmen to complete.",
    region: "East Asia",
    url: "https://www.smithsonianmag.com/history/terra-cotta-soldiers-on-the-march"
  },
  {
    title: "The Library of Alexandria",
    content: "The Great Library of Alexandria was one of the largest and most significant libraries of the ancient world. Founded in the 3rd century BCE, it may have housed up to 400,000 scrolls. The library was not just a repository of books but a research institution, museum, and think tank. Its destruction represents one of the greatest losses of ancient knowledge, though it didn't happen all at once but through several events over many years.",
    region: "Egypt",
    url: "https://www.ancient.eu/Library_of_Alexandria"
  },
  {
    title: "The Hanging Gardens of Babylon",
    content: "One of the Seven Wonders of the Ancient World, the Hanging Gardens were allegedly built by King Nebuchadnezzar II around 600 BCE for his wife, who missed the greenery of her homeland. The gardens were said to rise 75 feet through a series of ascending terraces. Despite its fame, no archaeological evidence of the gardens has been found, leading some historians to suggest they may have been purely legendary or located in a different city.",
    region: "Mesopotamia",
    url: "https://www.worldhistory.org/Hanging_Gardens_of_Babylon"
  },
  {
    title: "The Mysterious Collapse of the Maya Civilization",
    content: "The Maya civilization's sudden decline around 900 CE remains one of archaeology's greatest mysteries. Recent studies suggest a combination of factors including severe drought, overpopulation, environmental degradation, and political instability. The Maya's sophisticated understanding of astronomy, mathematics, and architecture makes their rapid collapse even more intriguing.",
    region: "South America",
    url: "https://www.scientificamerican.com/article/why-did-the-mayan-civilization-collapse"
  },
  {
    title: "The Battle of Thermopylae",
    content: "In 480 BCE, 300 Spartan warriors, along with several thousand allies, held off a massive Persian army at the narrow coastal pass of Thermopylae for three days. Led by King Leonidas, the Greeks used the terrain and their superior fighting skills to inflict heavy casualties on the Persians. Though the Greeks ultimately fell, their sacrifice bought time for the Greek city-states to unite and eventually defeat the Persian invasion.",
    region: "Mediterranean",
    url: "https://www.ancient.eu/thermopylae"
  },
  {
    title: "The Dead Sea Scrolls",
    content: "Discovered between 1947 and 1956, the Dead Sea Scrolls are ancient Jewish and Hebrew religious manuscripts found in the Qumran Caves. Dating from the 3rd century BCE to the 1st century CE, they include the oldest known Biblical manuscripts. The scrolls have revolutionized our understanding of Judaism and early Christianity, providing insights into religious practices and beliefs of the time.",
    region: "Mediterranean",
    url: "https://www.deadseascrolls.org.il"
  }
]

# Create the posts
posts_data.each do |post_data|
  post = user.posts.find_or_create_by!(title: post_data[:title]) do |p|
    p.content = post_data[:content]
    p.region = post_data[:region]
    p.url = post_data[:url]
  end
  
  # Add some random votes to make it interesting
  rand(5..20).times do
    # Create a random user for each vote
    voting_user = User.create!(
      email_address: "voter_#{SecureRandom.hex(4)}@example.com",
      password: 'password123',
      password_confirmation: 'password123'
    )
    post.votes.create!(user: voting_user)
  end
end

puts "Seed data created successfully!"
