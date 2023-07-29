class RedditUsersController < ApplicationController
    def get_saved_data
        reddit_username = params[:reddit_username]
        reddit_password = params[:reddit_password]

        client = OAuth2::Client.new(
        RedditApi::CLIENT_ID,
        RedditApi::CLIENT_SECRET,
        site: 'https://www.reddit.com',
        authorize_url: '/api/v1/authorize',
        token_url: '/api/v1/access_token'
        )
        access_token = client.password.get_token(reddit_username, reddit_password)

        response = access_token.get('https://oauth.reddit.com/user/' + reddit_username + '/saved')
        data = JSON.parse(response.body)

        saved_posts = data['data']['children'].select { |item| item['kind'] == 't3' }
        saved_comments = data['data']['children'].select { |item| item['kind'] == 't1' }

        posts_data = saved_posts.map { |post| { title: post['data']['title'], url: post['data']['url'] } }
        comments_data = saved_comments.map { |comment| { body: comment['data']['body'], post_url: "https://reddit.com#{comment['data']['permalink']}" } }

        render json: { saved_posts: posts_data, saved_comments: comments_data }
    rescue OAuth2::Error => e
        render json: { error: 'Invalid Reddit credentials' }, status: :unauthorized
    rescue StandardError => e
        render json: { error: 'An error occurred while fetching data from Reddit' }, status: :internal_server_error
    end
end
  