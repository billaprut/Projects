#!/usr/bin/env python
# coding: utf-8

# In[3]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings("ignore")

topics_list = ['ai', 'gaming', 'history', 'movies', 'music', 'softwareengineering']

badge_to_category = {
    # Question Badges
    "Altruist": "Question Badges",
    "Benefactor": "Question Badges",
    "Curious": "Question Badges",
    "Inquisitive": "Question Badges",
    "Socratic": "Question Badges",
    "Favorite Question": "Question Badges",
    "Stellar Question": "Question Badges",
    "Investor": "Question Badges",
    "Nice Question": "Question Badges",
    "Good Question": "Question Badges",
    "Great Question": "Question Badges",
    "Popular Question": "Question Badges",
    "Notable Question": "Question Badges",
    "Famous Question": "Question Badges",
    "Promoter": "Question Badges",
    "Scholar": "Question Badges",
    "Student": "Question Badges",

    # Answer Badges
    "Enlightened": "Answer Badges",
    "Explainer": "Answer Badges",
    "Refiner": "Answer Badges",
    "Illuminator": "Answer Badges",
    "Favorite Answer": "Answer Badges",
    "Stellar Answer": "Answer Badges",
    "Generalist": "Answer Badges",
    "Guru": "Answer Badges",
    "Lifejacket": "Answer Badges",
    "Lifeboat": "Answer Badges",
    "Nice Answer": "Answer Badges",
    "Good Answer": "Answer Badges",
    "Great Answer": "Answer Badges",
    "Populist": "Answer Badges",
    "Revival": "Answer Badges",
    "Necromancer": "Answer Badges",
    "Self-Learner": "Answer Badges",
    "Teacher": "Answer Badges",
    "Tenacious": "Answer Badges",
    "Unsung Hero": "Answer Badges",

    # Participation Badges
    "Autobiographer": "Participation Badges",
    "Caucus": "Participation Badges",
    "Constituent": "Participation Badges",
    "Commentator": "Participation Badges",
    "Pundit": "Participation Badges",
    "Enthusiast": "Participation Badges",
    "Fanatic": "Participation Badges",
    "Mortarboard": "Participation Badges",
    "Epic": "Participation Badges",
    "Legendary": "Participation Badges",
    "Precognitive": "Participation Badges",
    "Beta": "Participation Badges",
    "Quorum": "Participation Badges",
    "Convention": "Participation Badges",
    "Talkative": "Participation Badges",
    "Outspoken": "Participation Badges",
    "Yearling": "Participation Badges",

    # Moderation Badges
    "Citizen Patrol": "Moderation Badges",
    "Deputy": "Moderation Badges",
    "Marshal": "Moderation Badges",
    "Civic Duty": "Moderation Badges",
    "Cleanup": "Moderation Badges",
    "Constable": "Moderation Badges",
    "Sheriff": "Moderation Badges",
    "Critic": "Moderation Badges",
    "Custodian": "Moderation Badges",
    "Reviewer": "Moderation Badges",
    "Steward": "Moderation Badges",
    "Disciplined": "Moderation Badges",
    "Editor": "Moderation Badges",
    "Strunk & White": "Moderation Badges",
    "Copy Editor": "Moderation Badges",
    "Electorate": "Moderation Badges",
    "Excavator": "Moderation Badges",
    "Archaeologist": "Moderation Badges",
    "Organizer": "Moderation Badges",
    "Peer Pressure": "Moderation Badges",
    "Proofreader": "Moderation Badges",
    "Sportsmanship": "Moderation Badges",
    "Suffrage": "Moderation Badges",
    "Supporter": "Moderation Badges",
    "Synonymizer": "Moderation Badges",
    "Tag Editor": "Moderation Badges",
    "Research Assistant": "Moderation Badges",
    "Taxonomist": "Moderation Badges",
    "Vox Populi": "Moderation Badges",

    # Other Badges
    "Announcer": "Other Badges",
    "Booster": "Other Badges",
    "Publicist": "Other Badges",
    "Informed": "Other Badges",
    "Not a Robot": "Other Badges",
    "Staging Ground Beta": "Other Badges",

    # Retired Badges
    "Analytical": "Retired Badges",
    "Census": "Retired Badges",
    "Documentation Beta": "Retired Badges",
    "Documentation Pioneer": "Retired Badges",
    "Documentation User": "Retired Badges",
    "Reversal": "Retired Badges",
    "Tumbleweed": "Retired Badges"
}

# Set the width of the bars
bar_width = 0.15
bar_positions = np.arange(6)

# Colors for the bars
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf']

# Initialize a figure and axis
fig, ax = plt.subplots(figsize=(12, 8))

# Iterate through each topic and create a clustered bar chart
for i, topic in enumerate(topics_list):
    badges_df = pd.read_csv(f"/Users/pruthvishyambilla/Desktop/StackExchange_csv/{topic}.stackexchange.com/Badges.csv")['Name']

    categories_count = {
        "Question Badges": 0,
        "Answer Badges": 0,
        "Participation Badges": 0,
        "Moderation Badges": 0,
        "Other Badges": 0,
        "Retired Badges": 0
    }
    for badge in badges_df:
        category = badge_to_category.get(badge, None)
        if category:
            categories_count[category] += 1

    # Get category counts and labels
    counts = list(categories_count.values())
    categories = list(categories_count.keys())

    # Plotting the clustered bar chart for each topic
    ax.bar(bar_positions + i * bar_width, counts, bar_width, label=topic, color=colors[i % len(colors)])

# Set the labels and title
ax.set_xlabel('Badge Categories')
ax.set_ylabel('Badge Count')
ax.set_title('Badge Counts for Each Topic')
ax.set_xticks(bar_positions + (len(topics_list) / 2) * bar_width)
ax.set_xticklabels(categories)
ax.legend()
plt.tight_layout()
plt.savefig('Badges_topic.png')
plt.show()


# In[ ]:




